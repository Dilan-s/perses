int __attribute__((nomips16)) f1 (unsigned long long y) { return (int) ((int) (y >> 32) + 1); }
int __attribute__((nomips16)) f2 (unsigned long long y) { return (short) ((short) (y >> 32) + 1); }
int __attribute__((nomips16)) f3 (unsigned long long y) { return (char) ((char) (y >> 32) + 1); }
int __attribute__((nomips16)) f4 (unsigned long long y) { return (int) ((int) (y >> 33) + 1); }
int __attribute__((nomips16)) f5 (unsigned long long y) { return (short) ((short) (y >> 33) + 1); }
int __attribute__((nomips16)) f6 (unsigned long long y) { return (char) ((char) (y >> 33) + 1); }
int __attribute__((nomips16)) f7 (unsigned long long y) { return (int) ((int) (y >> 61) + 1); }
int __attribute__((nomips16)) f8 (unsigned long long y) { return (short) ((short) (y >> 61) + 1); }
int __attribute__((nomips16)) f9 (unsigned long long y) { return (char) ((char) (y >> 61) + 1); }