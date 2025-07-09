# Calculate append=skip

Fix for Keyboard Layout Issue
This fix addresses a problem with keyboard layouts where pressing "Y" in the Russian layout corresponds to "Н" (interpreted as "No") instead of confirming "Yes".

Changes:

Removed the ability to respond in Russian layout.
Now, pressing "Н" has no effect. Responses must be given in the English layout using "Y" or "N".
This ensures consistent behavior regardless of the active keyboard layout.
