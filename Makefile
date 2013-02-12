PIC=Kontur
LHMKONTUR_DIR=$(DESTDIR)/usr/share/backgrounds/$(PIC)
KDE_BG_DIR=$(DESTDIR)/usr/share/wallpapers/
MKDIR=/bin/mkdir -p
INSTALL=/usr/bin/install -p -m644 -D
#COLORS=LiMuxBlau Petrol BlauWin GelbLHM GrauLHM Weiss
COLORS=LiMuxBlau Petrol BlauWin Weiss
RES=1280x1024 1600x1200 1920x1200 1680x1050 1280x800\
	 	2560x1600 2560x1440 1920x1080 1366x768 1600x900
RES_LS43=640x480 800x600 1024x768 1152x864 1200x900 1280x960 1440x1080 
RES_LSWIDE=1024x600 1440x900 1280x720 1280x768

all: cut

install:
	$(MKDIR) $(LHMKONTUR_DIR)
	for re in $(RES); do \
		$(MKDIR) $(LHMKONTUR_DIR)/$${re} ; \
		$(INSTALL) cut/$${re}/*.png $(LHMKONTUR_DIR)/$${re}/ ; \
	done ; 
	for color in $(COLORS); do \
		$(MKDIR) $(KDE_BG_DIR)/$(PIC)-$${color}/contents/images ; \
		$(INSTALL) $(PIC)-metadata.desktop $(KDE_BG_DIR)/$(PIC)-$${color}/metadata.desktop ; \
		for re in $(RES); do \
			ln -s ../../../../backgrounds/$(PIC)/$${re}/${PIC}_$${color}.png \
		 		$(KDE_BG_DIR)/$(PIC)-$${color}/contents/images/$${re}.png ; \
		done ; \
		for re in $(RES_LS43); do \
			ln -s ../../../../backgrounds/$(PIC)/1600x1200/${PIC}_$${color}.png \
		 		$(KDE_BG_DIR)/$(PIC)-$${color}/contents/images/$${re}.png ; \
		done ; \
		for re in $(RES_LSWIDE); do \
			ln -s ../../../../backgrounds/$(PIC)/1920x1200/${PIC}_$${color}.png \
		 		$(KDE_BG_DIR)/$(PIC)-$${color}/contents/images/$${re}.png ; \
		done ; \
	done ;
		

blender.png:
	blender src/${PIC}.blend -o //../${PIC}_ -F PNG -b -f 1
	mv ${PIC}_0001.png blender.png

transparent.png: blender.png
	convert blender.png -alpha copy -channel alpha -gamma 1 -negate +channel -fx '#000' transparent.png

colored: transparent.png
	$(MKDIR) colored
	convert transparent.png -background 'rgb(90,110,130)'  -alpha remove colored/${PIC}_LiMuxBlau.png
	convert transparent.png -background 'rgb(29,95,122)'   -alpha remove colored/${PIC}_Petrol.png
	convert transparent.png -background 'rgb(51,110,165)'  -alpha remove colored/${PIC}_BlauWin.png
	#convert transparent.png -background 'rgb(255,204,0)'   -alpha remove colored/${PIC}_GelbLHM.png
	#convert transparent.png -background 'rgb(51,51,51)'    -alpha remove colored/${PIC}_GrauLHM.png
	#convert transparent.png -background 'rgb(102,100,140)' -alpha remove colored/${PIC}_Violett.png
	#convert transparent.png -background 'rgb(90,134,119)'  -alpha remove colored/${PIC}_Gras.png
	#cp transparent.png colored/${PIC}_Transparent.png
	cp blender.png colored/${PIC}_Weiss.png

cut: colored
	$(MKDIR) cut
	for color in $(COLORS); do \
		for re in $(RES); do \
			$(MKDIR) cut/$${re}; \
			convert colored/${PIC}_$${color}.png -filter Lanczos -resize $${re}^ -gravity center -crop $${re}+0+0 cut/$${re}/${PIC}_$${color}.png; \
		done; \
	done;

clean:
	rm -f mask.png
	rm -f transparent.png
	rm -rf colored
	rm -rf cut

mrproper: clean
	rm -f blender.png
