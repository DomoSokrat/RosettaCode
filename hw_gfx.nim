# Ubuntu: --no-install-recommends libgtk2.0-0
# Alpine: gtk+2.0 ttf-dejavu
import dialogs, gtk2
gtk2.nim_init()
 
info(nil, "Goodbye, World!")
