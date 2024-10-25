function  lag_yearly = PhaseShift2Lag(Period, PhaseShift)
    % Lags in  different Phases shifts
    for i = 1:length(Period)
        for j =1:size(PhaseShift, 2)
            if (PhaseShift(i,j) >= -Period(i)/4 && PhaseShift(i,j) <= Period(i)/4)
                lag_yearly(i,j) = PhaseShift(i,j);
            elseif PhaseShift(i,j) < -Period(i)/4
                lag_yearly(i,j) = Period(i)/2 - abs(PhaseShift(i,j));
            elseif PhaseShift(i,j) > Period(i)/4
                lag_yearly(i,j) = PhaseShift(i,j) - Period(i)/2;
            end
        end
    end
end

