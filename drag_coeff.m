% wind drag coefficient
function C10 = drag_coeff(w10)
    % input: w10, wind speed at 10 m

    if(length(w10)==1)
        if w10 <= 0.1
            C10 = 0.0621;
        elseif w10 <= 3.85
            C10 = 0.0044*w10.^(-1.15);
        else
            C10 = -7.12e-7*w10.^2+7.387e-5*w10+6.605e-4;
        end
    else
        C10 = w10*0;
        C10(w10<=0.1) = 0.0621;
        pp = (w10>0.1 & w10<=3.85);
        C10(pp) = 0.0044*w10(pp).^(-1.15);
        pp = (w10>3.85);
        C10(pp) = -7.12e-7*w10(pp).^2+7.387e-5*w10(pp)+6.605e-4;
        C10 = C10';
    end

end

