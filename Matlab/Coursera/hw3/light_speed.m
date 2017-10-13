function [tempo, milhas] = light_speed(d)
c = 300000 * 60;
tempo = d ./ c;
milhas = d ./ 1.609;

