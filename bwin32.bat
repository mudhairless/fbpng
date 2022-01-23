@echo off

fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/file_to_buffer.bas -c -o src/o/file_to_buffer.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/IDAT.bas -c -o src/o/IDAT.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/IHDR.bas -c -o src/o/IHDR.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/PLTE.bas -c -o src/o/PLTE.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/plte_conv.bas -c -o src/o/plte_conv.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_destroy.bas -c -o src/o/png_destroy.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_dimensions.bas -c -o src/o/png_dimensions.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_gfxlib2.bas -c -o src/o/png_gfxlib2.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_image.bas -c -o src/o/png_image.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_image_convert.bas -c -o src/o/png_image_convert.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_image_deinit.bas -c -o src/o/png_image_deinit.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_image_init.bas -c -o src/o/png_image_init.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_image_prepare.bas -c -o src/o/png_image_prepare.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_image_store.bas -c -o src/o/png_image_store.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_load.bas -c -o src/o/png_load.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_load2.bas -c -o src/o/png_load2.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_memory.bas -c -o src/o/png_memory.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_opengl.bas -c -o src/o/png_opengl.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_pixelformat.bas -c -o src/o/png_pixelformat.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_save.bas -c -o src/o/png_save.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_save2.bas -c -o src/o/png_save2.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/png_tables.bas -c -o src/o/png_tables.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/row_conv_abgr32.bas -c -o src/o/row_conv_abgr32.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/row_conv_argb32.bas -c -o src/o/row_conv_argb32.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/row_conv_p8.bas -c -o src/o/row_conv_p8.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/row_conv_rgb16.bas -c -o src/o/row_conv_rgb16.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/row_conv_rgb32.bas -c -o src/o/row_conv_rgb32.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc src/tRNS.bas -c -o src/o/tRNS.o
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc -lib -x build/fbpng src/o/file_to_buffer.o src/o/IDAT.o src/o/IHDR.o src/o/PLTE.o src/o/plte_conv.o src/o/png_destroy.o src/o/png_dimensions.o src/o/png_gfxlib2.o src/o/png_image.o src/o/png_image_convert.o src/o/png_image_deinit.o src/o/png_image_init.o src/o/png_image_prepare.o src/o/png_image_store.o src/o/png_load.o src/o/png_load2.o src/o/png_memory.o src/o/png_opengl.o src/o/png_pixelformat.o src/o/png_save.o src/o/png_save2.o src/o/png_tables.o src/o/row_conv_abgr32.o src/o/row_conv_argb32.o src/o/row_conv_p8.o src/o/row_conv_rgb16.o src/o/row_conv_rgb32.o src/o/tRNS.o 
rem fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc -lib -x build/fbpng src/o/file_to_buffer.o src/o/IDAT.o src/o/IHDR.o src/o/PLTE.o src/o/plte_conv.o src/o/png_dimensions.o src/o/png_image.o src/o/png_image_convert.o src/o/png_image_deinit.o src/o/png_image_init.o src/o/png_image_prepare.o src/o/png_image_store.o src/o/png_load2.o src/o/png_memory.o src/o/png_pixelformat.o src/o/png_save2.o src/o/png_tables.osrc/o/row_conv_argb32.o src/o/row_conv_p8.o src/o/tRNS.o

fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test1.bas -x tests/test1.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test2.bas -x tests/test2.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test3.bas -x tests/test3.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test4.bas -x tests/test4.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test5.bas -x tests/test5.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test6.bas -x tests/test6.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test7.bas -x tests/test7.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test8.bas -x tests/test8.exe -p build/
fbc %1 %2 %3 %4 %5 %6 %7 %8 %9  -i inc tests/test9.bas -x tests/test9.exe -p build/
