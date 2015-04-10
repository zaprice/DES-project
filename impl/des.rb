class DES

  attr_accessor :key, :left_subkey, :right_subkey, :ctr

  SHIFTS = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

  def initialize
    @ctr = 0
  end

  def encrypt block
    block = initial_permutation block
    16.times do
      left = block[0..3]
      right = block[4..7]
      tmp = feistel right
      block = right.concat(left.zip(tmp).map { |left, right| xor(left, right) })
    end
    @ctr = 0
    # Un-flip the last round
    final_permutation block[4..7].concat block[0..3]
  end

  def initial_permutation block
    permute block, read_perm("config/initial_permutation.txt")
  end

  def final_permutation block
    permute block, read_perm("config/final_permutation.txt")
  end

  def feistel  half_block
    bit_shuffle( s_box( expand( half_block).zip(get_subkey).map { |byte, key| xor(byte, key) }))
  end

  # Aids diffusion of key material
  def expand  half_block
    permute half_block, read_perm("config/expansion.txt")
  end

  # Ensures non-linearity from plaintext to ciphertext
  # Each bit of ciphertext should depend on many bits of input
  def s_box expanded_block
    block_in_bits = bytes_to_bits expanded_block
    s_boxes = load_sboxes
    half_block = []

    block_in_bits.each_slice(6).each_with_index do |six_bits, index|
      y = [six_bits[0], six_bits[5]].join.to_i(2)
      x = six_bits[1..4].join.to_i(2)
      half_block.concat pad_word(s_boxes[index][y][x].to_s(2).split(""))
    end
    bits_to_bytes half_block
  end

  # Diffusion of key material and s-box changes
  # Each bit of input should change many bits of output
  def bit_shuffle  half_block
    permute half_block, read_perm("config/bit_shuffle.txt")
  end

  # Returns round keys for each Feistel node
  # Relies on internal state of tmp_subkey
  def get_subkey
    if ctr == 0
      selected_bits = bytes_to_bits permuted_choice_1 @key
      @left_subkey = selected_bits[0..27]
      @right_subkey = selected_bits[28..55]
    end

    @left_subkey = shift @left_subkey, SHIFTS[ctr]
    @right_subkey = shift @right_subkey, SHIFTS[ctr]
    @ctr += 1
    permuted_choice_2 bits_to_bytes @left_subkey.dup.concat(@right_subkey)
  end

  def permuted_choice_1 key
    permute key, read_perm("config/permuted_choice_1.txt")
  end

  def permuted_choice_2 key
    permute key, read_perm("config/permuted_choice_2.txt")
  end

  ##############################################################################
  # Helper functions
  ##############################################################################

  def xor(hex1, hex2)
    [hex1].pack("H*").bytes.zip([hex2].pack("H*").bytes).map { |arr| arr[0] ^ arr[1] }.pack("c*").unpack("H*").first
  end

  def bytes_to_bits block
    block.map { |byte| hex_to_bin byte }.flatten
  end

  def bits_to_bytes block
    block.each_slice(8).map { |bits| pad_byte bits.join.to_i(2).to_s(16) }
  end

  def pad_bits byte_in_bits
    (["0"]*(8 - byte_in_bits.size)).concat(byte_in_bits)
  end

  def pad_word word_bits
    (["0"]*(4 - word_bits.size)).concat(word_bits)
  end

  def pad_byte byte
    ("0"*(2 - byte.size)).concat(byte)
  end

  def hex_to_bin hex
    pad_bits [hex].pack("H*").bytes[0].to_s(2).split("")
  end

  def read_perm filename
    File.read(filename).strip.split(" ").to_i
  end

  def read_sbox index
    matrix = []
    File.open("config/s_#{index}.txt") do |file|
      file.each_line do |line|
        matrix.push line.strip.split(" ").to_i
      end
    end
    matrix
  end

  def load_sboxes
    (1..8).map { |index| read_sbox index }
  end

  def permute block, permutation
    bits = bytes_to_bits(block)
    permuted_bits = permutation.map { |index| bits[index - 1]}
    bits_to_bytes permuted_bits
  end

  def shift subkey, value
    removed = subkey.shift value
    subkey.concat(removed)
  end
end

class Array
  def to_i
    self.map { |int| int.to_i }
  end
end
