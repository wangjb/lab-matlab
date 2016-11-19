%fx = IBWread('J:\JB''s experiment\2016Nov\FieldY_BYP2.ibw');
%%fx = fx.y;
filepath = 'J:\JB''s experiment\2016Nov\2016Nov17_EddyCurrentMeasurement\EddyQuad_P05.txt';
[fx, fy, fz]= textread(filepath, '%f %f %f %*f %*f %*f','headerlines',7);
field = [fx, fy, fz];
field = field.';
clear fx fy fz;
names = {'FieldX' 'FieldY' 'FieldZ'};
t = (0:(length(field)-1))/10000;

harmonics = [60, 120, 180, 300];

for j = 1:3
    filtered = field(j,:);
    for i = 1:length(harmonics)
        d = designfilt('bandstopiir','FilterOrder',20, ...
        'HalfPowerFrequency1',(harmonics(i)-1),'HalfPowerFrequency2',(harmonics(i)+1), ...
        'DesignMethod','butter','SampleRate',10000);
        filtered = filtfilt(d,filtered);
    end
    subplot(3,1,j);
    plot(t,field(j,:),t,filtered);
    ylabel('Voltage (V)');
    xlabel('Time (s)');
    title(strcat('EddyQuad P05 filtered ',char(names(j))));
    legend('Unfiltered','Filtered');
    grid;
    csvwrite(strcat('EddyQuad_P05_filtered_',char(names(j)),'.dat'),filtered);
end
