class DES

  attr_accessor :key, :tmp_subkey

  def encrypt block
    block = initial_permutation block
    16.times do
      left = block[0..7]
      right = block[8..15]
      block = append(right, xor(left, feistel(right)))
    end
    return final_permutation block
  end

  def initial_permutation

  end

  def final_permutation

  end

  def feistel half-block
    expanded_block = expand half-block
    return bit_shuffle(s_box(xor(expanded_block, get_subkey)))
  end

  # Aids diffusion of key material
  def expand

  end

  # Ensures non-linearity from plaintext to ciphertext
  # Each bit of ciphertext should depend on many bits of input
  def s_box

  end

  # Diffusion of key material and s-box changes
  # Each bit of input should change many bits of output
  def bit_shuffle

  end

  def get_subkey

  end
  
end
