{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MagicHash #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}

module CLaSH.Prelude.BitIndex where

import GHC.TypeLits                   (KnownNat, type (+), type (-))

import CLaSH.Class.BitConvert         (BitConvert (..))
import CLaSH.Promoted.Nat             (SNat)
import CLaSH.Sized.Internal.BitVector (BitVector, Bit, index#, lsb#, msb#,
                                       replaceBit#, setSlice#, slice#, split#)

{-# INLINE (!) #-}
-- | Get the bit at the specified bit index.
--
-- __NB:__ Bit indices are __DESCENDING__.
(!) :: (BitConvert a, KnownNat (BitSize a), Integral i) => a -> i -> Bit
(!) v i = index# (pack v) (fromIntegral i)

{-# INLINE slice #-}
-- | Get a slice between bit index @m@ and and bit index @n@.
--
-- __NB:__ Bit indices are __DESCENDING__.
slice :: (BitConvert a, BitSize a ~ ((m + 1) + i)) => a -> SNat m -> SNat n
      -> BitVector (m + 1 - n)
slice v m n = slice# (pack v) m n

{-# INLINE split #-}
-- | Split a value of a bit size @m + n@ into a tuple of values with size @m@
-- and size @n@.
split :: (BitConvert a, BitSize a ~ (m + n), KnownNat n) => a
      -> (BitVector m, BitVector n)
split v = split# (pack v)

{-# INLINE replaceBit #-}
-- | Set the bit at the specified index
--
-- __NB:__ Bit indices are __DESCENDING__.
replaceBit :: (BitConvert a, KnownNat (BitSize a), Integral i) => a -> i -> Bit
           -> a
replaceBit v i b = unpack (replaceBit# (pack v) (fromIntegral i) b)

{-# INLINE setSlice #-}
-- | Set the bits between bit index @m@ and bit index @n@.
--
-- __NB:__ Bit indices are __DESCENDING__.
setSlice :: (BitConvert a, BitSize a ~ ((m + 1) + i)) => a -> SNat m -> SNat n
         -> BitVector (m + 1 - n) -> a
setSlice v m n w = unpack (setSlice# (pack v) m n w)

{-# INLINE msb #-}
-- | Get the most significant bit.
msb :: (BitConvert a, KnownNat (BitSize a)) => a -> Bit
msb v = msb# (pack v)

{-# INLINE lsb #-}
-- | Get the least significant bit.
lsb :: BitConvert a => a -> Bit
lsb v = lsb# (pack v)