function coeff_compression = coeff_compression_image(histogramme,dico);
nb_bit = 0;
nb_bit_huffman = 0;
for i=1:length(histogramme)
    nb_bit = nb_bit + histogramme(i) *8;
    nb_bit_huffman = nb_bit_huffman + histogramme(i) * length(dico{i, 2});
end; 

coeff_compression = nb_bit / nb_bit_huffman;
end