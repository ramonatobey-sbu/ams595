%homework 2 AMS 595
%Ramona Tobey id:117607747
%In this homework we are approximating borders of the Mandelbrot set
%using a polynomial
%need to create: 
% function it = fractal(c) 
%which takes complex c and returns the number of iterations 
% till divergence
% function m = bisection(fn_f, s, e) 
% which takes a function fn_f, 
% bounds s and e on the initial guess and
%returns a point where the point sign of f changes
%Then I need to fit a polynomial to these points and measure its length
%%
%My first step will be to create the function which tests if a 
% point belongs to a set. The input will be the complex number c,
% written in the form r+i

function it = fractal(c)
    it = 0;
    z = 0;
    while (it < 100 && abs(z) <2)
        z = z^2 + c; 
        it = it + 1;
    end
end
%%
%our indicator function should take in a point x and create an indicator
%function along that line
function fn = indicator_fn_at_x(x)
    fn = @(y) (fractal(x + 1i * y) < 100) * 2 - 1; %note: this is different than what was given 
end
%%
%defining the bisection function
function m = bisection(fn_f, s, e)
    m = (s+e)/2;
    if abs(s-e) > .0001
        if fn_f(m) == 1
            m = bisection(fn_f, s, m);
        else
            m = bisection(fn_f, m, e);
        end
    end
end
%%
%now I need to define an array with at least 1000 points between -2 and 1
%then evaluate each of those with my bisection function and store the
%corresponding m value in another array.

%creating the arrays
xValues = linspace(-2, 1, 2000);
yValues = zeros(size(xValues));
for i = 1:length(xValues)
    fn_f = indicator_fn_at_x(xValues(i));
    yValues(i) = bisection(fn_f, 0, 2);
end
% Now that we have the yValues, we can visualize the results using a plot
figure; %[output:71fa4e9e]
plot(xValues, yValues); %[output:71fa4e9e]
xlabel('X, real'); %[output:71fa4e9e]
ylabel('Y, imaginary'); %[output:71fa4e9e]
title('Mandelbrot Set Approximation'); %[output:71fa4e9e]
axis([-2 1 0 2]); %[output:71fa4e9e]


% The next step is to inspect this graph and discard all the zero value
% before I fit a polynomial to the points
% it seems like it's between -1.78 and 0.4. If I have 2000 values in my
% matrix, (2-1.78)/3 = .07333 = 146th enrty and (2.4/3) = 1600th entry
%Important Note! Although there is a bump out by x=-1.78, my polyfit
%function seemed to be less accurate when I included that in the domain, so
%I changed my lower bound to be from x=-1.4 instead
nonZeroX = xValues(400:1600);
nonZeroy = yValues(400:1600);
%%
%Now, I want to fit a degree 15 polynomial to these new points
p = polyfit(nonZeroX, nonZeroy, 15);
%I want to graph this polynomial on my mandelbrot set to see if it is a
%good match
y = polyval(p, nonZeroX);
hold on; % Keep the current plot %[output:65b4c935]
plot(nonZeroX, y, 'r--');  %[output:65b4c935]
hold off;  %[output:65b4c935]
%This seems to be a good fit for my fractal so now I will estimate its
%length
%%
%This is where I will create my poly_len function
%We are also supposed to create an anonymous function ds that only takes in
%one argument
ds = @(x) sqrt(1 + (polyval(polyder(p),x)).^2); 
lengthEstimate = integral(ds, -1.39, .39); 
disp(['Border Length: ', num2str(lengthEstimate)]); %[output:4c2b4aee]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":28.3}
%---
%[output:71fa4e9e]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAN8AAACGCAYAAABdeF8TAAAAAXNSR0IArs4c6QAAFLNJREFUeF7tXVuMVtUV3lofHGMNgiYVKEIUik8ixDAdtdoYKjECiT7A+EZGQqyISRmYAYpibGCGWyLUJgTNlKQy+KAJ0BiNMZV4qdSAmJS0RY2AoE0UJDyIxgvNt+36Xf+ec\/6zzzl773P510kIDLMva317fWetfVvnogsXLlxQ8ggCgkBwBC4S8gXHXDoUBDQCQj4xBEGgIASCk+\/MmTOqp6dHvffee2rOnDlqYGBAdXR0qPfff18tXLhQffLJJ2rx4sWqr6\/PGSTUZ2dnZ2K7b7\/9trr\/\/vvVrl271I033qj6+\/u1HCRnXqHOnz+vtm7dqhYtWqRGjx4d2RzJQL+ELJA96bFpm3BGW0NDQ2ry5MlJzRby+8HBQQUcnnnmmVicsgiGNo8fP67mz5\/fsLmHH35Y\/xz6KZR8Y8eObRgAN7g6ky\/JqOhFsWDBAjV37lxN\/hMnTlgZYVLbMK7nnntOrVy5UtvZ+vXrCzG60EZO\/dGLpyiymXoXRj4I8tlnn6lNmzbptzoZDv4PHpE8H\/5\/+\/btWm54InoTUvk777xTbdmyRXEioyz3pGgPBsw9HzdC7oGjPN+5c+d0\/\/v372\/qh8riZQEZ6aXB+0Y98ly8T1Ne00BmzJgR6W155JC2bXhGkJn0ueKKK5r6MPVB+\/xFSJhPmDBB7du3T4tMupHOd9xxh3rttdcUyX\/y5MlGRMPLkyz0Yjl69KiOOOiFwF8kr7zyitq2bZuOmJ544gnd75o1a9Thw4e1HNwuzBcM4TxmzJhGxEV63XvvvVo2TkY+Rrxd0g8vxVdffVVHbnmdRGHkGzVqlAZx6tSpOgQDsCASFCOSwBiGh4e1gdAgEjGJlBj8KVOm6PpUL25gCSxOMLNuFPkOHjyoPTQNIIwPMmEAYDB8EMy3KwYThkMhXpJ34sQ1jYr0Am7of+\/evZnahrHh4XLhZ04+vPzIEIlgHHMKyYk8p0+f1obMXxpJWNDvUQftEK6Yhpjkg7cGMSkaAOkgF8YE\/ZJdoM1169apzZs3ax1hF9Qu2RCRrZV848ePb5pyUF3Sz8Q+izcvjHwAZNq0adqAMNC9vb1q1apVaseOHU0eCkpx70eGjv\/DAMCo44AikM05n0kA\/Iy5JidU3JyPkwkGR\/NDmpOZZEvqO2rQ+NuXh4emsdDPZvQQN0\/isqFd863PXzzQJ0l2Xp5IYHoRTvCouTcfWz63jfJ8US8wIpg5n4+KbFqRj0hNLza8AKL0I5KbWFWOfPPmzVOPPvqoQqhy5MgRHYKChAQkAQjCkXek3\/HBAVB8YcQEmQ\/60qVLdVkKmwg08jIU\/mQln0nsJAOOGzTuASl0IrKbdaJCNXMxx\/SaaMNcTHJNviQsIAP3fnxRKyv5SAeQ5LHHHlOPP\/64hotHT1Geb9asWU3RE48EuIelupUn34oVK9SSJUsaK5\/0MwhGJCHgYDw8tLQhH72l0hAgabUzhOfj5OKhX5R34WVbhbTmCiqvRx7HNfmSogB6IdCLkC8AZSWfjV1Ekc\/W89WGfPRmAvgA3nz7RMX9POykpWjT89Fb3ZzMZ53z0fyC5ofmnI+HS0nznKQ5nznP4gZshtdp5nw8TKftBZLVDKVoAQrtY65lzvn43Muc8\/GwMwkL0vXpp59We\/bsUTS3hnxZyRf1ciR9XMz5akM+WjSgATYXP8zQ6+qrr25MnrFXFkc+kNHcT3S12skXQeJCj6iQkQyee6C4\/Ts+D8KLhJeLW+3kYVJcHb6ggTJxC1NYScS8EfPgKG8UtcIct4wfhwXpYS6G8AU1Gl9a7bSZ83F8EK7DZvBAH3pJ42WKfh544AH14IMPxq52Ru1DV5J8ptG02x5Tlgl56DpJ85gkrx1a3qr3F2y1EwM3ceLEppMFtEpXdRDrIr+QL+xIBiMfV4vCne7ubqtjU2Ehkd4EgTAIFEI+vhEad74xjPrSiyBQHALByYe537Jly\/SGunmoF6tR+COPIFAmBLDKjD+un6Dka+XxQLrly5erAwcOuNZR2hMEciEwc+ZMtXHjRucEDEY+EG\/nzp1q9erVesnXfGiyDyXHjRuXC6yyVT516pT26BjEOj511g\/O4Mknn2za7nE1hkHIZ55kIOH5\/lXSSpsrhaUdQSANAj7tMgj5bJT1qaRN\/1JGEIhCwKddCvnE5gSBFggI+cQ8BIGCEBDyFQS8dCsICPnEBgSBghAQ8hUEvHQrCAj5xAYEgYIQEPIVBLx0KwgI+cQGBIGCEAhGvjSZnV1j4VNJ17JKe+2DgE+7jNxk56kO4pK7uobfp5KuZZX22gcBn3aZeMIlLvuya\/h9KulaVmmvfRDwaZcjyGceguZJZBCWIg8iso65vgTrU8n2MRXR1DUCPu2yiXwy53M9dNJe1REISr48ng05E48dOxb5GS7To5rfIfCpZNUNQOQvDgGfdjki7ORZxtKoTLkm477c0ip9BPrxqWQaPaSsIMAR8GmXkWEnvr5jPqan4r+Hx7v22mv1J7TwRH3YMilpkk8lxZwEgawI+LTLxNXONELD+8WRL+7LO9S+TyXT6CBlBYFCPF9e2FuRj7dNCzvwkPRpLZ7D5b777ssritQXBJwg4NMpjPB8pociDVqFnVTGlny0+NLV1dX4LDEp+cgjjyj8kUcQKAMCSJ4UJIESXxR54YUX1O233974ZDOlem8FSFLYibr0IXp8DmzDhg2N3J0+3zBlGESRoZoIPP\/88zqlZdxHbfJoNWLBhbYa8GUY2jaw3Vw3yQcvSoRr9S02lBHy5RlGqesLAZ922UQ+Hg5Onz5dkXc6dOiQ2r17t\/7MkuuTLbLg4stspF0XCAQjH4TlXg7eD9\/Ow+PD7YZaVXIxCNJGeyIQlHxFQexTyaJ0kn6rj4BPu3S6z5cHap9K5pFL6rY3Aj7tcgT5+F0+DrvNVkOeYfKpZB65pG57I+DTLiOPl\/HN71DQ+1QylA7ST\/0Q8GmXsVsNvlY144bHp5L1MwnRKBQCPu0y8oRL3LUgnwr7VNKn3NJ2vRHwaZdObjW4gN+nki7kkzbaEwGfdimrne1pU6K1JQLeyUcb60uXLlW9vb0q7X0+Sz1aFvOppAv5pI32RMCnXYrna0+bEq0tERDyWQIlxQQB1wgEIx9dco0KO6GUzwS6PpV0PSDSXvsg4NMurbYaKCsZ7vcNDw+rgYEB1dHRkWkE4hIp+VQyk6BSSRDwfNXNapOdL8hs3bo1c9Jcyn6NUR0aGmpcpMXPQj6x9TIi4NMuI+\/zHTx4sEEOIsyMGTPUvHnz1J49ezJ5PhB4x44davbs2Wrt2rVNt9iFfGU0O5HJt10mfigFAuAu35QpU9SyZcvUqlWrmjxW2iECmc0UEr6VTCujlBcECIFgni8E5Enk27hxo5LsZSFGQvqwQaCtyCfZy2xMQsqEQiBY9jIolCd1oA0gSZ7Pd7oKGxmljCBACATNXkbzuiypA22GTMhng5KUKQsCwcJOM3lS2tSBeQDzqWQeuaRueyPg0y4ldWB725a19ifOfKWG3\/lU4e+num+wrlf1gsHIB6AkdWDVzcW9\/CDc4MsfqTc\/PKt+fuWlasLoS1XfXZP033V\/gpKvKDB9KlmUTnXo940PzqqPv\/hKPTT8L9V310Tt+Ybf+a\/2ft03\/6wOKrbUwaddypWi2ptPegVBMJDt1utHaaLhgacD2UDGuX96V3s9\/Iz\/r\/MTlHySOrDOppSsG8iGEDMpvCSCokV4wbqGoMHIF\/XdvOThclPCp5JuJGyPVuDxQECEmEleDeVQvs4hqE+7tLrVEMLsfCoZQv669EHksyXU6N\/9TciXcfCt7vNlbDtVNSFfKri8FQb5EFLue+gmqz5APjxntvzaqnzVCvm0S6dfps0DrE8l88jVbnWFfM0j7tMuR4SdLq4NZTFYn0pmkadd6wj5CiIfPo6Jm+qLFi3y9hHMOKMW8oWhO0JKPFGrk9hGwEonnrRh597f3tTUZl1WP33aZeRXivbv36\/wsZSQj08lQ+pR9r5Avml\/+LsWEyua3Tdfo38GWYiYt1w3ypp8qEv10Cb2\/vgmPDwpTsYc\/v0vyw5NpHw+7VLSxVfSJKKFJhLA2PGcOHNe3XLdlXqznJ45T72ryQCC4W\/yULStAPKgHVvPRWXxN\/68+eEXavDlY7o+9gpxOobOg1bxREww8mW1Q55ycM6cOZE5Xuh77\/v27dPdmN\/786lkVr2qVg8hIzd8kAsGj20DkI6IAGIgTKTfpyGbDSZExCW7cSRtkg5lQXZ4Wf4i+OEFAcL+IGcZH592qT1f3nTxg4ODauLEiWru3Lmqv79fdXd3q87OziYs41IGUiGfSpZxUH3IRF6NCIc5HAgAD0TeDsQLfSsBcuBGBMJRIj6FuRSW4mcQNLRsSePg0y5zn+00T8VQjk9zzohLtOvWrVObN2+OXMzxqWQSwHX5Pc2\/6HQKJx88kOl1QutN8sDbUdjLCYczo3SGNLRscf35tEsn5OPbEyDfW2+9NSL0NNNTrF+\/Xs2fP7+hs08lyzKQvuWgDW9+NMx1SJlXBwoz4fHw8M15yG9zrC2vDGnq+7TLYOTjCkedISUlJXtZGtP4say5ipl0LjNbL+5qwQvi4d4YnrtsNyVKT76enh69NYF5XlzYyYeNFl+6uroa3o+UlOxl6Q2cDjijJoVxtquV6XvzV6OM5AuavSwLtDYLLiAlHoSaUUmUfL5hsuhU9jp0yRWLKbQxXoZ5XR7cyki+YNnLsgLHtxoWL17c2KDnhDO3GmTOlxVtpWhuRyuGZV0pTKshyIeXSZnuB\/p0ClZzvjhypQW3VXmfSrqUswxtEfloflTmfbI0ePEDALbH29K0n6WsT7u0Il8WodPW8alkWlnKXp6Tr2z7YnmwowxpOChQlitKPu2yscmOLwjhm+xZv7uXB3TU9alkXtnKVJ\/nUCnbnpgLnGjxCF496kSMiz7StOHTLhuejz4FhuNhoQ9VC\/nszIGOj6F02fbD7DSwK0XhJ0rjGFyRhwOCkI9goc7MBRE72LKX8qlkdqnKVZOM0jbFQ7mkt5eGv2TainyAKOrb7OZBaHso7UrWnXx5T5pQtjAsrpRlPmQ3stlK0by2bcjHtwPE89kbDd7UIMet118ZeTqfDg+jRbrXFnXCo1WP1EYd53lRelMip7YgHzbKt2\/frvg+nb355S9ZVc8H0uFAME6W0IOwEAsHu\/7xaSPx7B8X3NBINkuHilHXdu6GkBNPWZbg84946xbouFztyUffS5fVzvQmRauPlEaBboX\/sCgyqelCKx0qxiXXCaM7NDnpqk+r0yntMtfj6LcN+dKbnPsaVfV8nHxYlcPPOHFic7aSyPjGB180SBgVutJF2KqmYshiLUK+LKhlrFNF8iG0hBfD33mJQQsquG3OkxHRvpdteJoR\/tJVE\/IFHJIqkQ+GQZ\/MAkSursHQ\/BF\/g8zwnugHBDSzgwUcmkK6EvIFhL1K5CNv5GsxgMJMtE\/pF\/J61oBD6aQrIZ8TGO0aqRL5QqTDo9VNngTJDsl6lBLyOR5Hnkpi165dTUmWqkI+Cg1dhZpxEPMLsnU\/0RKFgZDPIfl4AqWjR4+q4eHhpjwvZSQfpcDDIgj25kLPwdJ+McjhcBXelJDP4RDwxEo4SWN+E6Js5KOPRNLmOaW9g1FQaj6H8EQ25Xtu6Vv+PO0L+fKgZ9TluV1aJVBCDpeZM2da9\/zRTyaqSd8dsy5vUxBtYpVx0nfH9QkUep498q169sg3auVtP1W3XfOtTVONMgcOHFDjx49X48aNs64Hj4u7bZABN7zL\/GTRr5U+3192lbrnzx+r1TO+bjo9FBqDU6dOqeXLlytzmuRCjmCXaZPId\/LkSTV91V9T6XTJ5\/9WX02dpy75\/D+R9S7+8nOFQWz1oAwelKPy3182Rl385Wl1+RsbRlT99qpf6N9RvVQCS2FrBDAe534zqHEG3kU\/h9bdo1+eLp+g5KN8nlFhJ5SiFT78G4CDBK0enCjBtwiwHI8whR6e24T\/P2+Ln0DhZX419rvUXs3lgEhbPyJw\/OvL1V\/++U0pIPFxpjYY+ZIWXEqBsAghCAREIBj5oBNtNYwdO1YNDQ2pyZMnB1RVuhIEyoVAUPKVS3WRRhAoFoHSkM+8PR\/6Mm+oYUj6WlMoOVz10+rghKs+im7H15iVhnyU9ZoyWi9cuFBt2rRpxKfGih6IPP1Tkiq0UYewux3m8T7HrDTk40ZN6SyivvOXx\/iLrEsXlmfPnq3Wrl2rNmzYUPk5b9LBiSLxdtG37zErJfmSvuXnAtii2oj6TkVRsuTtN2nvNm\/7Zanva8xKRz5f8XXdB7II\/YR8+VAvjHyUsAni09GdOnm8KP2gq6+3aD4zyFa77mEnoeJrzAojnzncUHDnzp1q9erVhaWsz2aC6Wr5Gsh0Urgp3Q4LLj5fmKUgn\/n5MDINH4dZ3Zhd9lbqRD6g0A4HJ3yNWSnIl92UpaYgUF0EhHzVHTuRvOIICPkqPoAifnUREPJVd+xE8oojIOSr+ACK+NVFQMhXwrFDPpve3t6m8590xjDUedc6HvEr21AL+co2Iv+Xh29g47\/6+\/tVV1eXwsHzEI+Qzz\/KQj7\/GGfqgYwfhMNDKTg6Ojpatkf1zp49q15\/\/fXG6SF+4oZf1zKvctEn4oR8mYYtVSUhXyq4whbOcp2FSINsAX19fVpg7kWRqIqua+Frw9yj8s1kJAvC7+p0syTs6CX3JuRLxqiwEkQkCDAwMGB17I57TISo5s9oi9+d5MrxQ+1CPv\/DLuTzj3HmHuCxXnrpJV0f9wBt5ntmuBh3dI\/CS0pWTEJSfh0hX+Zhs64o5LOGKmxBHgKi5xUrVlhdwI0jX1T4aCYvFs8XdoyFfGHxtuqNSLFgwYKGt+PztlaLLlELJebVn56eHoW2Z82apfBvzA07Ozv13HDbtm16i0M8n9VQ5Sok5MsFn\/vKcfM8cyElbt4Wt0rJVzsp5KTFmJUrV2pF1qxZow4fPqwXWWgxRhZc3I8xtSjk84et15YRluLP3Xff7bUfadwfAkI+f9h6bfnFF1\/UCZgk8bBXmL02LuTzCq80LgjEI\/A\/GQvpqkj0\/9IAAAAASUVORK5CYII=","height":134,"width":223}}
%---
%[output:65b4c935]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAN8AAACGCAYAAABdeF8TAAAAAXNSR0IArs4c6QAAFzhJREFUeF7tXQ+MVtWVP3ZJWoxlEWtbYRyHVBB3E0HILuOAK8ZlZd0FWo0LQ7epEySUgrDKnxmgCMRmmOFfA0h1guzApvJBDWQHGv\/UsgxhQKgLDsmyVdQ4TAfLropIsmpTqtvfnTmfd968933ve+\/d+973vvMSAjO8e+85v3t+79x77r3nXvX5559\/TvIIAoKAdQSuEvJZx1waFAQUAkI+MQRBICYErJPv4sWLNHPmTDp9+jRNnjyZGhoaqH\/\/\/vTmm29STU0NvfvuuzR79myqra2NDBJus7KyMm+9x48fpxkzZtCuXbto5MiRVFdXp+RgOcMK9cknn9DmzZtp1qxZNGjQINfqWAb+T8gC2fM9fupmnFFXc3MzDRs2LF+1sfx\/Y2MjAYft27d74hREMNR57tw5mjZtWtbmHnnkEfWz7SdW8g0ePDhrALrBpZl8+YyKPxTTp0+nKVOmKPJ3dnb6MsJ8dcO49uzZQ0uXLlV2tmbNmliMzraRc3v84YmLbE69YyMfBHnvvfdo\/fr16qvOhoPfwSOy58Pvm5qalNzwRPwl5Pfvuece2rhxI+lExru6J0V9MGDd8+lGqHtgN893+fJl1f7hw4d7tcPv4mMBGfmjobeNcuy59Dad8joNZMyYMa7eVh85FFo3PCPIzPoMGDCgVxtOfVC\/\/iFkzMvLy+nAgQNKZNaNdZ4wYQK1trYSy9\/V1ZUd0ejvsyz8YTl79qwacfAHQf+QvPzyy7RlyxY1YnriiSdUuytWrKD29nYlh24Xzg8M43zddddlR1ys1\/33369k08mo95FeL+uHj+LBgwfVyC2sk4iNfAMHDlQgjhgxQg3BACyIBMWYJDCGTCajDIQ7kYnJpETnDx8+XJXncl4dy2DpBHOWdSPfyZMnlYfmDoTxQSZ0AAxG7wTn1xWdCcPhIV4+76QT12lUrBdwQ\/v79+8PVDeMDY8uF37WyYePHxsiE0zHnIfkTJ4PPvhAGbL+0ciHBf8\/yqAexhXTECf54K1BTB4NgHSQC32CdtkuUGd9fT1t2LBB6Qi74HrZhphsueQrKyvrNeXgsqyfE\/sg3jw28gGQUaNGKQNCRy9atIiWLVtG27Zt6+WhoJTu\/djQ8Tt0AIzaCygG2TnncxIAP2OuqRPKa86nkwkGx\/NDnpM5yZavbbdO07+++vDQaSz8s3P04DVP0mVDvc6vvv7hgT75ZNffZxI4vYhOcLe5t963+tzWzfO5fcCYYM75vNvIJhf5mNT8YcMHwE0\/JrkTq6Ij39SpU+nxxx8nDFXOnDmjhqAgIQPJAIJw7B35\/\/TOAVB6YMQJst7p8+fPV+\/ysIlBYy\/Dw5+g5HMSO58Be3Wa7gF56MRkd5ZxG6o5gzlOr4k6nMGkqMmXDwvIoHs\/PagVlHysA0iycuVKWr16tYJLHz25eb6JEyf2Gj3pIwHdw3LZoiffkiVLaN68ednIJ\/8MgjFJGDgYjz609EM+\/koVQoB80U4bnk8nlz70c\/Mu+ru5hrTOCKpejj1O1OTLNwrgDwJ\/CPUAUFDy+bELN\/L59XypIR9\/mQA+gHd+fdzG\/fqwk0PRTs\/HX3XnZD7onI\/nFzw\/dM759OFSvnlOvjmfc56lG7BzeF3InE8fpvPyAsvqHEpxAAr1Y67lnPPpcy\/nnE8fdubDgnV95plnqKWlhXhuDfmCks\/t48j6RDHnSw35OGjAHewMfjiHXtdff3128oy1Mi\/ygYzO9cSoop16EMRr6OE2ZGSD1z2Q1\/qdPg\/Ch0R\/zyvaqQ+TvMroAQ284xWYQiQR80bMg928kVuE2SuM74UF6+EMhugBNe5fjnb6mfPp+GC4DpvBA334I42PKdp5+OGHac6cOZ7RTrd16KIkn9NoSm2NKciE3HaZfPOYfF7btrzF3p61aCc6rqKiotfOAo7SFTuIaZFfyGe3J62RT1eLhzvV1dW+tk3ZhURaEwTsIBAL+fSFUK\/9jXbUl1YEgfgQsE4+zP0WLlyoFtSdm3oRjcIfeQSBJCGAKDP+RP1YJV8ujwfSLV68mE6cOBG1jlKfIBAKgbFjx9K6desiJ6A18oF4O3fupOXLl6uQr\/PhyT6UHDJkSCiwklb4\/PnzyqOjE9P4pFk\/OINNmzb1Wu6Jqg+tkM+5k4GF19ev8kXaolJY6hEECkHApF1aIZ8fZU0q6ad9eUcQcEPApF0K+cTmBIEcCAj5xDwEgZgQEPLFBLw0KwgI+cQGBIGYEBDyxQS8NCsICPnEBgSBmBAQ8sUEvDQrCAj5xAYEgZgQsEa+QjI7R42FSSWjllXqKx0ETNql6yK7nurAK7lr1PCbVDJqWaW+0kHApF3m3eHilX05avhNKhm1rFJf6SBg0i77kM+5CVpPIoNhKfIgIutY1IdgTSpZOqYimkaNgEm77EU+mfNF3XVSX7EjYJV8YTwbciZ2dHS4XsPl9KjOewhMKlnsBiDyx4eASbvsM+zUs4wVojLnmvS6uSVX+gi0Y1LJQvSQdwUBHQGTduk67MTtO87H6an0\/4fHu+mmm9QVWnjcLrbMlzTJpJJiToJAUARM2mXeaGchQsP7eZHP6+Ydrt+kkoXoIO8KArF4vrCw5yKfXjcHduAh+WotPYfLAw88EFYUKS8IRIKASafQx\/M5PRRrkGvYye\/4JR8HX6qqqrLXErOSCxYsIPyRRxBIAgJInmQlgZIeFNm3bx\/ddddd2SubOdV7LkDyDTtRli+ix3Vga9euzebuNPmFSUInigzFicDevXtVSkuvS23CaNUn4MJLDbgZhpcN\/C6uO8kHL8qEy3UXG94R8oXpRilrCgGTdtmLfPpwcPTo0cTe6dSpU7R79251zVLUO1sk4GLKbKTeKBCwRj4Iq3s5eD\/cnYfHhNu1FVWKohOkjtJEwCr54oLYpJJx6STtFj8CJu0y0nW+MFCbVDKMXFK2tBEwaZd9yKef5dNh97PUEKabTCoZRi4pW9oImLRL1+1l+uK3LehNKmlLB2knfQiYtEvPpQZTUU2v7jGpZPpMQjSyhYBJu3Td4eJ1LMikwiaVNCm31J1uBEzaZSSnGqKA36SSUcgndZQmAibtUqKdpWlTorVPBIyTjxfW58+fT4sWLaJCz\/P51CPnayaVjEI+qaM0ETBpl+L5StOmRGufCAj5fAIlrwkCUSNgjXx8yNVt2AmlTCbQNalk1B0i9ZUOAibt0tdSA2clw\/m+TCZDDQ0N1L9\/\/0A94JVIyaSSgQSVQoKA4aNuvhbZ9YDM5s2bAyfN5ezX6NXm5ubsQVr8LOQTW08iAibt0vU838mTJ7PkYMKMGTOGpk6dSi0tLYE8Hwi8bds2mjRpEq1atarXKXYhXxLNTmQybZd5L0qBADjLN3z4cFq4cCEtW7asl8cqtItAZmcKCdNKFiqjvC8IMALWPJ8NyPORb926dSTZy2z0hLThB4GSIp9kL\/NjEvKOLQSsZS+DQmFSB\/oBJJ\/nM52uwo+M8o4gwAhYzV7G87ogqQP9dJmQzw9K8k5SELA27HQmTyo0dWAYwEwqGUYuKVvaCJi0S0kdWNq25Vv7zoufUubV3xH+3lp9q+9yxf6iNfIBKEkdWOzmEr38IFzjS+\/Q0bcv0Y3XfoXKB32Fau8dqv5O+2OVfHGBaVLJuHRKQ7ttb12i3374Kc3N\/IZq762g6iUzKHP1LVS+uYGq\/+qbaVAxpw4m7VKOFKXefApXEJ4OZBt\/80DKvHpBVQBPp8i2ejV1bnyaqKKCMmt3qd+n+bFKPkkdmGZTyq8byIYh5o2XL1D57SPch5cdHUR3301tV\/6cGuua1RwwrUNQa+Rzuzcvf3dF84ZJJaORsDRqgcc7erCd2rfPoD9twiVaudJdcRBw6FBqKxtJv933YmqHoCbt0tepBhtmZ1JJG\/KnpY3GplaqXlJN5fdPwtGT3Gq1tioP2Ln3he73U\/iYtEtf5\/lsYGpSSRvyp6INeLOaGiL8\/c47vlRqvOMhqj2+k+jQIaIJE3yVKaaXTNplpDfThgHVpJJh5Cqpsj3BlMa6f6WtS\/\/el+qDHjtE+597lMb3+8g3YX1VnJCXTNpln2FnFMeGguBmUskg8pRcmR07VCRz7t\/VUudtY+nA3Nt9QQDylV++QO0Hl6kIqPKAKXpM2mWfHS44qT5r1ixjl2B69YtJJVNkC6FVwTICnl7RSRCvpoba\/nkBNVZ+X\/1\/IeTD+\/v\/8iMq\/84X8760RD9N2qXrLUWHDx8mXJZi8zGppE09kt4WyDfqx68oMbFoXnv831RUE6RrvKObeOO+NdA3+VAXExplsRaI5QosP+DfKnr69iVq\/9EdSYfGVT6Tdinp4ovSJNyFZhLA2PF0XvyExn3rWrVYzs\/kra8pMoBgihTbZ9DR8VO7lxV6yIN6\/Houfhd\/48\/Rtz+kxpc6VHlsRcPuGN4PWow7YqyRL6gd6ikHJ0+e7Jrjhe97P3DggGrGed+fSSWD6lVs5bA4rgz\/8gUa13Wayj+6QOP6XaLxN19Lmf\/9svJsTJb9P7xdka\/6\/16nztsqfZPNDyZMxPIxtypit5WNUh8ART5EUvFgfjhhQg9hLyV2ndCkXSrPFzZdfGNjI1VUVNCUKVOorq6OqqurqbKyslc\/eaUM5JdMKunHYNLwDrza+J9t6g79w\/MN+CZ1DvhGVjXsRoFHsnIqAWuAq1d3k62jIyvL+K7T6t\/4QCgZb6ukUffUK7ngja3IVkBnm7TL0Hs7nbtiOMenc86IQ7T19fW0YcMG12COSSULwLp4X+3ooMzcBhrX1kL00Pep\/NEfUNuVgTRv92\/U8A97MPXhpzVFQT54uY6OrDzwjMojH2mhcV3tVH76uBJnyk9f+2IPqTUBczdk0i4jIZ++PAHyHTt2rM\/Q05meYs2aNTRt2rSs5iaVTEg\/mhWD1+juAPFmZzc8FzJ\/Mytgd+3d88JLKhCD5+LGu7PNYtlCBYEStFnbpF1aI5\/esW57SFlJyV4WgAI9xJvy4EY1pEuaAbtphKNKeHRvjMgp5oVCPp824HfYqVfHwZeqqqqs92PySfYyn8BrryG0z56E501+o5WFt2auRBLJZzV7WRBo\/QRcMOzEg6GmWxIlk+49iE5JL8OHXDGfQ5QTT2zzuojAypLvy+cSs0\/UWvayoBjqSw2zZ8\/OLtDrhHMuNcicLyjaRJgb4YF34zldEiOFhWoI8j3ZNEctjSRlm5pJp+BrzudFrkLBzfW+SSWjlDMJdTH5eH6k1utSkNIBSyXlB\/bQ1pcauzdpI0oa82PSLn2Rz4b+JpW0Ib\/NNlRU8JWd1Dm\/NnHrYmFw4Axp1f9U5e88YZjGfJY1aZfZRXbcIIQ72YPeu+dTF8\/XTCoZVrYklcdcLzOvgba+sYc6NzyVukOsKmfMQw\/RuJsHUueGp+NZm9Q63KRdZj0fXwWG7WG2N1VDV5NKJok8YWRBYCXz3HHa\/9xjifEMYfTxKovNAtU\/XUqDHv0Pwja4WDYH9Ahn0i5dTzXMmDGDnAEREyDrdZpU0rTsturPbh+7cLg7IJGAOZEJ3du2\/zuNf\/g7NPnBjVRbX1M65AOYbnezOzdCRw162skXdqcJp\/M7MG907sRGUXdMXPVddRXNvbeWqp+sKw3y6csB4vn8Wx2GgyAHQuRuUUc+05YNo0+YQG3fXaAa8DukQh1IbJTWdA190B46VCXnvbFlt2+M\/PeY\/zdNOoXssBML5U1NTaSv0\/kXMfybJpUML513DSAdNgRjnU2Rqa2Fqj9+gzI\/XEO7fv27bOLZJ6ffSke\/9y9qN3\/1f7+ktoFhO1j1g5W+tlOpedDzTd0ZxVKYqKgPwjhZ\/6vXiA61ppt8fF+6RDsLpymij\/MaXqAnb\/if7mMyO3aqxe9RM7uzOesHWnlTMXb4I6BAra1qaNU5eVrO3Slz17xAW5fdVxrDTe4CHEdatYra3vww3eQr3OSiL1G0nu\/U69Q5dTrhnBpC5J2P1KpAiK+9lWxgZSNp3uynlPfsM3TtyQ6tzsCd7k7\/UAoPp7soqWhnXB1blOTrIY86Cb5pTbDhYE\/iWRB27i3T1MlvGByTF+te4\/72dsr8\/Jiv4Wlc\/Rd1u0K+qBHNUV8xkU+lSfjJ01S+uVGRBTtNQh2DgXcDkXfsoFFPHFPBGyQcAgHV2t6rF3oR0mK3xNaUkM8i9EVFvgV13XO7x37gfZdBEOx6Tn1jPQ+Jh+ABcSElyFes2b+CwIAyQr6gyAUoVzTk68lx2Th9JdVmujN+mXhAQDy8aTppuU1M6KzXKeSLGGE9lcSuXbt6JVkqFvLx0oLpE9f6AVnOgRlxdyS6OpUGcejQ2LfRmbRLa6ca9ARKZ8+epUwm0yvPi0klA1kZZ9y6+KkaAiISaXsOhoV1PQFtID2KtJBalrnz21T91zfkvy3JoI4m7dIa+fTESthJ47wTwqSSBfWNdlMPdli0\/egnqjhIwIdX4fVsDAPZ+8Udbi8Iv4hezpLv67+P9WCtSbu0Sr6Ojg51YiJXAiXkcBk7dqzvLnznzypo6B97ErH6LuX9Ytn27fTZz39BmNNt\/WUjdfXrR2VvvUXHX3mFnj1zhZ498wdaeudX6c4brhTU2okTJ6isrIyGDBniuxw8LpLgIiES0kUk+QmiXy59Prv6a3Rk9o\/pu\/\/5LHUdORKb6ufPn6fFixeTc5oUhUCJIV9XVxeNXvaLgnTq9\/7r9OmIqdTv\/Tdcy33p4\/cJnZjrwTt48B7+ve9Qk\/r52\/+wnEa01tOQK1eo7MoV2nvNNer3V752C33p4w\/Uu\/KYQwD9Meerf6ESAH\/9e0+Za8hnzafq\/1F9PKN8rJKP83m6DTuhFEf48G8Y+GdXX5dTV2xKxl0ECMfrl3XouU303+uV6TtQ9Hf+ZvAfC\/ZqUXaI1PUFAud+fw397L\/+kAhI\/N7aVIiw1siXL+BSiNDyriCQBgSskQ9g8VLD4MGDqbm5mYYNG5YGDEUHQSAQAlbJF0hCKSQIpBSBxJDPeXre9mFeW\/2b77YmW3JE1U6ujRNRtRF3Pab6LDHk46zXnNG6pqaG1q9f3+eqsbg7Ikz7nKQKdaRh2F0K83iTfZYY8ulGzeks3O75C2P8cZblA8uTJk360xnRVbR27dqin\/Pm2zgRJ95RtG26zxJJvnx3+UUBbFx1uN1TEZcsYdvV72J02zgRtv6klDfVZ4kjn6nxddo7Mg79hHzhUI+NfJywCeLz1p00eTw3\/aCrqa9oODMIVjrtw05GxVSfxUY+Z3dDwZ07d9Ly5ctjS1kfzAQLK2WqIwuTIpq3SyHgYvKDmQjyOa8PY9MwsZk1GrMLXkuayAcUSmHjhKk+SwT5gpuylBQEihcBIV\/x9p1IXuQICPmKvANF\/OJFQMhXvH0nkhc5AkK+Iu9AEb94ERDyJbDvkDdk0aJFvfZ\/8h5DW\/td07jFL2ldLeRLWo\/0yKMvYONXdXV1VFVVRdh4buMR8plHWchnHuNALbDxg3B4OAVH\/\/79c9bH5S5dukRHjhzJ7h7Sd9zox7WcR7n4ijghX6BuK6iQkK8guOy+HOQ4C5MG2QKQKQ6P7kWRqIqPa+G2Yd2j6ovJSBaE\/0vTyRK7vZe\/NSFffoxie4OJBAEaGhp8bbvTPSaGqM6fUZd+dlJXTt\/ULuQz3+1CPvMYB24BHuvFF19U5XEO0M98zzlc9Nq6x8NLTgrLQnJ+HSFf4G7zXVDI5xsquy\/qQ0C0vGTJEl8HcL3I5zZ8dJ7BE89nt4+FfHbx9tUak2L69OlZb6fP23IFXdwCJc6jPzNnziTUPXHiRMK\/MTesrKxUc8MtW7aoJQ7xfL66KtRLQr5Q8EVf2Gue5wykeM3bvKKUerSTh5wcjFm6dKlSZMWKFdTe3q6CLByMkYBL9H3MNQr5zGFrtGYMS\/HnvvvuM9qOVG4OASGfOWyN1vz888+rBEySeNgozEYrF\/IZhVcqFwS8Efh\/yDEIuU+qpDIAAAAASUVORK5CYII=","height":134,"width":223}}
%---
%[output:4c2b4aee]
%   data: {"dataType":"text","outputData":{"text":"Border Length: 2.8557\n","truncated":false}}
%---
