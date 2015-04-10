# The DES Deconstruction Project

The purpose of this project is to demonstrate the necessity of each step in a Feistel network by performing practical attacks on a cipher with those steps removed.

### Any implementations of cryptographic software in this repository are **NOT SAFE FOR GENERAL USE**.

In a cipher based on a [Feistel network](https://en.wikipedia.org/wiki/Feistel_cipher), there are two stages that each defeat particular classes of attacks:

* The **S-boxes** provide _non-linearity_ in the ciphertext with respect to the plaintext and key, ensuring that linear relationships do not exist between the ciphertext and the inputs. A cipher without non-linearity is vulnerable to [linear cryptanalytic attacks](https://en.wikipedia.org/wiki/Linear_cryptanalysis).
* The **bit shuffle** and **plaintext expansion** functions provide _diffusion_, ensuring that small changes in input lead to unpredictable changes in output. A cipher without diffusion is vulnerable to [differential cryptanalytic attacks](https://en.wikipedia.org/wiki/Differential_cryptanalysis).

We will use [DES](https://en.wikipedia.org/wiki/Data_Encryption_Standard) as our cipher, since it is well-known, well-studied, and easy to implement.
We will perform a practical attack resulting in either key or plaintext retrieval on two modified versions of DES; each version will have one of the above steps omitted to demonstrate the kind of attacks each property protects against.


#####Copyright (C) 2015  Zachary Price

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
