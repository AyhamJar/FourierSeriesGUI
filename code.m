>> classdef FSgenerator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        PhaseShiftdegreesSpinner       matlab.ui.control.Spinner
        PhaseShiftdegreesSpinnerLabel  matlab.ui.control.Label
        HorizontalShiftSpinner         matlab.ui.control.Spinner
        HorizontalShiftSpinnerLabel    matlab.ui.control.Label
        ImpulsetrainButton             matlab.ui.control.Button
        RectangularwaveButton          matlab.ui.control.Button
        HalfwaverectifiedButton        matlab.ui.control.Button
        FullwaverectifiedButton        matlab.ui.control.Button
        TriangularwaveButton           matlab.ui.control.Button
        SawtoothButton                 matlab.ui.control.Button
        SquarewaveButton               matlab.ui.control.Button
        AmplitudeSpinner               matlab.ui.control.Spinner
        AmplitudeSpinnerLabel          matlab.ui.control.Label
        NoofHarmonicsSpinner           matlab.ui.control.Spinner
        NoofHarmonicsSpinnerLabel      matlab.ui.control.Label
        FrequencySpinner               matlab.ui.control.Spinner
        FrequencySpinnerLabel          matlab.ui.control.Label
        TimedomainSpinner              matlab.ui.control.Spinner
        TimedomainSpinnerLabel         matlab.ui.control.Label
        UIAxes                         matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        A % Amplitude
        N % Harmonics
        freq % Frequency
        n % Time domain
        hs % Horizontal Shift
        ps % Phase Shift
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: TimedomainSpinner
        function TimedomainSpinnerValueChanged(app, event)
            app.n = app.TimedomainSpinner.Value;
       
        end

        % Value changed function: FrequencySpinner
        function FrequencySpinnerValueChanged(app, event)
            app.freq = app.FrequencySpinner.Value;
            
        end

        % Value changed function: NoofHarmonicsSpinner
        function NoofHarmonicsSpinnerValueChanged(app, event)
            app.N = app.NoofHarmonicsSpinner.Value;
            
        end

        % Value changed function: AmplitudeSpinner
        function AmplitudeSpinnerValueChanged(app, event)
            app.A = app.AmplitudeSpinner.Value;
            
        end

        % Button pushed function: SquarewaveButton
        function SquarewaveButtonPushed(app, event)
            t = linspace(-app.n,app.n,app.N);
f = 0*t;
w0 = 2*pi*app.freq;
            for k=-app.N:1:app.N
    if(k==0)
        continue;
    end
    C_k = ((app.A)/(1i*pi*k))*(1-exp(-1i*pi*k));
    f_k = C_k*exp(1i*k*w0*(t-app.ps));
    f = f + f_k;
            end
        
plot(app.UIAxes, t, f+app.hs, 'LineWidth', 2);
        end

        % Button pushed function: SawtoothButton
        function SawtoothButtonPushed(app, event)
                        t = linspace(-app.n,app.n,app.N);
f = 0*t;
w0 = 2*pi*app.freq;
for k=-app.N:1:app.N
    if(k==0)
        C_k =(app.A/2);
    else C_k = ((app.A*1i)/(2*pi*k));
    end
    f_k = C_k*exp(1i*k*w0*(t-app.ps));
    f = f + f_k;
end
plot(app.UIAxes, t, f+app.hs, 'LineWidth', 2);
        end

        % Button pushed function: TriangularwaveButton
        function TriangularwaveButtonPushed(app, event)
                  t = linspace(-app.n,app.n,app.N);
f = 0*t;
w0 = 2*pi*app.freq;
 for L=1:length(t)
fs = 0;
for k=1:app.N
    an = ( (4*app.A*sin(2*pi*k)/(2*pi*k)) + (4*app.A*cos(2*pi*k)/(2*pi*k)^2)- (4*app.A/(2*pi*k)^2));
    bn = ( (4*app.A*sin(2*pi*k)/(2*pi*k)^2) + (cos(2*pi*k)/(2*pi*k)));
      C0 = app.A/2;
      an = -(4*app.A)/((pi^2)*(2*k-1)^2);
      bn = 0;
      fs = fs + (an*cos((2*k-1)*w0*(t(L)-app.ps)));
end
f(L) = C0 + fs;
 end
 plot(app.UIAxes, t, f+app.hs, 'LineWidth', 2);
        end

        % Button pushed function: FullwaverectifiedButton
        function FullwaverectifiedButtonPushed(app, event)
             t = linspace(-app.n,app.n,app.N);
f = 0*t;
w0 = 2*pi*app.freq;
for k=-app.N:1:app.N
    if(k==0)
        C_k =(2*app.A/pi);
    else  C_k = ((-2*app.A)/(pi*((4*k^2)-1)));
    end
    f_k = C_k*exp(1i*k*w0*(t-app.ps));
    f = f + f_k;
end
 plot(app.UIAxes, t, f+app.hs, 'LineWidth', 2);
        end

        % Button pushed function: HalfwaverectifiedButton
        function HalfwaverectifiedButtonPushed(app, event)
            t = linspace(-app.n,app.n,app.N);
f = 0*t;
w0 = 2*pi*app.freq;
for k=-app.N:1:app.N
    
    C_k = ((cos(2*k*w0*t))/((4*k^2)-1));
    
end
    f_k = app.A/pi + (app.A/2)*sin(w0*(t-app.ps)) - ((2*app.A)/pi)*C_k + 0.1833*app.A;
    f = f + f_k;
    plot(app.UIAxes, t, f+app.hs, 'LineWidth', 2);
        end

        % Button pushed function: RectangularwaveButton
        function RectangularwaveButtonPushed(app, event)
            t = linspace(-app.n,app.n,app.N);
f = 0*t;
w0 = 2*pi*app.freq;
for L=1:length(t)
fs = 0;
for k=1:app.N
    an = ( (4*app.A*sin(2*pi*k)/(2*pi*k)) + (4*app.A*cos(2*pi*k)/(2*pi*k)^2)- (4*app.A/(2*pi*k)^2));
    bn = ( (4*app.A*sin(2*pi*k)/(2*pi*k)^2) + (cos(2*pi*k)/(2*pi*k)));
      C0 = app.A/2;
      an =( (2*app.A)/(k*pi))*sin((pi*k)/2);
      bn = 0;
      fs = fs +((an*cos(k*w0*(t(L)-app.ps)))+(bn*sin(k*w0*(t(L)-app.ps))));
end
f(L) = C0 + fs;
end
    plot(app.UIAxes, t, f+app.hs, 'LineWidth', 2);
        end

        % Button pushed function: ImpulsetrainButton
        function ImpulsetrainButtonPushed(app, event)
            t = linspace(-app.n,app.n,app.N);
f = 0*t;
w0 = 2*pi*app.freq;
for L=1:length(t)
fs = 0;
for k=1:app.N
    an = ( (4*app.A*sin(2*pi*k)/(2*pi*k)) + (4*app.A*cos(2*pi*k)/(2*pi*k)^2)- (4*app.A/(2*pi*k)^2));
    bn = ( (4*app.A*sin(2*pi*k)/(2*pi*k)^2) + (cos(2*pi*k)/(2*pi*k)));
      E0 = 0.00495*app.n;
      dis = E0*app.freq;
      C0 = app.A*dis;
      an = ((2*app.A)/(k*pi))*sin((pi*k)*dis);
      bn = 0;
      fs = fs +((an*cos(k*w0*(t(L)-app.ps)))+(bn*sin(k*w0*(t(L)-app.ps))));
end
f(L) = C0 + fs;
end
plot(app.UIAxes, t, f+app.hs, 'LineWidth', 2);
        end

        % Value changed function: HorizontalShiftSpinner
        function HorizontalShiftSpinnerValueChanged(app, event)
            app.hs = app.HorizontalShiftSpinner.Value+0;
            
        end

        % Value changed function: PhaseShiftdegreesSpinner
        function PhaseShiftdegreesSpinnerValueChanged(app, event)
            app.ps = app.PhaseShiftdegreesSpinner.Value*(pi/180)+0;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9294 0.6941 0.1255];
            app.UIFigure.Position = [100 100 656 549];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Fourier Series')
            xlabel(app.UIAxes, 't')
            ylabel(app.UIAxes, 'f(t)')
            app.UIAxes.PlotBoxAspectRatio = [2.23970037453184 1 1];
            app.UIAxes.FontName = 'Arial';
            app.UIAxes.XTickLabelRotation = 0;
            app.UIAxes.YTickLabelRotation = 0;
            app.UIAxes.ZTickLabelRotation = 0;
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.ZGrid = 'on';
            app.UIAxes.FontSize = 14;
            app.UIAxes.Position = [1 222 656 340];

            % Create TimedomainSpinnerLabel
            app.TimedomainSpinnerLabel = uilabel(app.UIFigure);
            app.TimedomainSpinnerLabel.BackgroundColor = [0.9294 0.6941 0.1255];
            app.TimedomainSpinnerLabel.HorizontalAlignment = 'right';
            app.TimedomainSpinnerLabel.FontName = 'Arial';
            app.TimedomainSpinnerLabel.FontSize = 15;
            app.TimedomainSpinnerLabel.Position = [41 185 92 22];
            app.TimedomainSpinnerLabel.Text = 'Time domain';

            % Create TimedomainSpinner
            app.TimedomainSpinner = uispinner(app.UIFigure);
            app.TimedomainSpinner.ValueChangedFcn = createCallbackFcn(app, @TimedomainSpinnerValueChanged, true);
            app.TimedomainSpinner.FontName = 'Arial';
            app.TimedomainSpinner.FontSize = 15;
            app.TimedomainSpinner.Position = [148 185 100 22];

            % Create FrequencySpinnerLabel
            app.FrequencySpinnerLabel = uilabel(app.UIFigure);
            app.FrequencySpinnerLabel.HorizontalAlignment = 'right';
            app.FrequencySpinnerLabel.FontName = 'Arial';
            app.FrequencySpinnerLabel.FontSize = 15;
            app.FrequencySpinnerLabel.Position = [57 155 76 22];
            app.FrequencySpinnerLabel.Text = 'Frequency';

            % Create FrequencySpinner
            app.FrequencySpinner = uispinner(app.UIFigure);
            app.FrequencySpinner.ValueChangedFcn = createCallbackFcn(app, @FrequencySpinnerValueChanged, true);
            app.FrequencySpinner.FontName = 'Arial';
            app.FrequencySpinner.FontSize = 15;
            app.FrequencySpinner.Position = [148 155 100 22];

            % Create NoofHarmonicsSpinnerLabel
            app.NoofHarmonicsSpinnerLabel = uilabel(app.UIFigure);
            app.NoofHarmonicsSpinnerLabel.HorizontalAlignment = 'right';
            app.NoofHarmonicsSpinnerLabel.FontName = 'Arial';
            app.NoofHarmonicsSpinnerLabel.FontSize = 15;
            app.NoofHarmonicsSpinnerLabel.Position = [12 81 121 22];
            app.NoofHarmonicsSpinnerLabel.Text = 'No. of Harmonics';

            % Create NoofHarmonicsSpinner
            app.NoofHarmonicsSpinner = uispinner(app.UIFigure);
            app.NoofHarmonicsSpinner.ValueChangedFcn = createCallbackFcn(app, @NoofHarmonicsSpinnerValueChanged, true);
            app.NoofHarmonicsSpinner.FontName = 'Arial';
            app.NoofHarmonicsSpinner.FontSize = 15;
            app.NoofHarmonicsSpinner.Position = [148 81 100 22];

            % Create AmplitudeSpinnerLabel
            app.AmplitudeSpinnerLabel = uilabel(app.UIFigure);
            app.AmplitudeSpinnerLabel.BackgroundColor = [0.9294 0.6941 0.1255];
            app.AmplitudeSpinnerLabel.HorizontalAlignment = 'right';
            app.AmplitudeSpinnerLabel.FontName = 'Arial';
            app.AmplitudeSpinnerLabel.FontSize = 15;
            app.AmplitudeSpinnerLabel.Position = [61 119 72 22];
            app.AmplitudeSpinnerLabel.Text = 'Amplitude';

            % Create AmplitudeSpinner
            app.AmplitudeSpinner = uispinner(app.UIFigure);
            app.AmplitudeSpinner.ValueChangedFcn = createCallbackFcn(app, @AmplitudeSpinnerValueChanged, true);
            app.AmplitudeSpinner.FontName = 'Arial';
            app.AmplitudeSpinner.FontSize = 15;
            app.AmplitudeSpinner.BackgroundColor = [0.9412 0.9412 0.9412];
            app.AmplitudeSpinner.Position = [148 119 100 22];

            % Create SquarewaveButton
            app.SquarewaveButton = uibutton(app.UIFigure, 'push');
            app.SquarewaveButton.ButtonPushedFcn = createCallbackFcn(app, @SquarewaveButtonPushed, true);
            app.SquarewaveButton.BackgroundColor = [0.502 0.502 0.502];
            app.SquarewaveButton.FontSize = 20;
            app.SquarewaveButton.FontColor = [1 1 1];
            app.SquarewaveButton.Position = [304 176 132 31];
            app.SquarewaveButton.Text = 'Square wave';

            % Create SawtoothButton
            app.SawtoothButton = uibutton(app.UIFigure, 'push');
            app.SawtoothButton.ButtonPushedFcn = createCallbackFcn(app, @SawtoothButtonPushed, true);
            app.SawtoothButton.BackgroundColor = [0.502 0.502 0.502];
            app.SawtoothButton.FontSize = 20;
            app.SawtoothButton.FontColor = [1 1 1];
            app.SawtoothButton.Position = [456 176 100 31];
            app.SawtoothButton.Text = 'Sawtooth';

            % Create TriangularwaveButton
            app.TriangularwaveButton = uibutton(app.UIFigure, 'push');
            app.TriangularwaveButton.ButtonPushedFcn = createCallbackFcn(app, @TriangularwaveButtonPushed, true);
            app.TriangularwaveButton.BackgroundColor = [0.502 0.502 0.502];
            app.TriangularwaveButton.FontSize = 20;
            app.TriangularwaveButton.FontColor = [1 1 1];
            app.TriangularwaveButton.Position = [280 132 157 31];
            app.TriangularwaveButton.Text = 'Triangular wave';

            % Create FullwaverectifiedButton
            app.FullwaverectifiedButton = uibutton(app.UIFigure, 'push');
            app.FullwaverectifiedButton.ButtonPushedFcn = createCallbackFcn(app, @FullwaverectifiedButtonPushed, true);
            app.FullwaverectifiedButton.BackgroundColor = [0.502 0.502 0.502];
            app.FullwaverectifiedButton.FontSize = 20;
            app.FullwaverectifiedButton.FontColor = [1 1 1];
            app.FullwaverectifiedButton.Position = [456 132 177 31];
            app.FullwaverectifiedButton.Text = 'Full-wave rectified';

            % Create HalfwaverectifiedButton
            app.HalfwaverectifiedButton = uibutton(app.UIFigure, 'push');
            app.HalfwaverectifiedButton.ButtonPushedFcn = createCallbackFcn(app, @HalfwaverectifiedButtonPushed, true);
            app.HalfwaverectifiedButton.BackgroundColor = [0.502 0.502 0.502];
            app.HalfwaverectifiedButton.FontSize = 20;
            app.HalfwaverectifiedButton.FontColor = [1 1 1];
            app.HalfwaverectifiedButton.Position = [259 81 180 31];
            app.HalfwaverectifiedButton.Text = 'Half-wave rectified';

            % Create RectangularwaveButton
            app.RectangularwaveButton = uibutton(app.UIFigure, 'push');
            app.RectangularwaveButton.ButtonPushedFcn = createCallbackFcn(app, @RectangularwaveButtonPushed, true);
            app.RectangularwaveButton.BackgroundColor = [0.502 0.502 0.502];
            app.RectangularwaveButton.FontSize = 20;
            app.RectangularwaveButton.FontColor = [1 1 1];
            app.RectangularwaveButton.Position = [456 81 176 31];
            app.RectangularwaveButton.Text = 'Rectangular wave';

            % Create ImpulsetrainButton
            app.ImpulsetrainButton = uibutton(app.UIFigure, 'push');
            app.ImpulsetrainButton.ButtonPushedFcn = createCallbackFcn(app, @ImpulsetrainButtonPushed, true);
            app.ImpulsetrainButton.BackgroundColor = [0.502 0.502 0.502];
            app.ImpulsetrainButton.FontSize = 20;
            app.ImpulsetrainButton.FontColor = [1 1 1];
            app.ImpulsetrainButton.Position = [379 34 130 31];
            app.ImpulsetrainButton.Text = 'Impulse train';

            % Create HorizontalShiftSpinnerLabel
            app.HorizontalShiftSpinnerLabel = uilabel(app.UIFigure);
            app.HorizontalShiftSpinnerLabel.HorizontalAlignment = 'right';
            app.HorizontalShiftSpinnerLabel.FontName = 'Arial';
            app.HorizontalShiftSpinnerLabel.FontSize = 15;
            app.HorizontalShiftSpinnerLabel.Position = [38 43 107 22];
            app.HorizontalShiftSpinnerLabel.Text = 'Horizontal Shift';

            % Create HorizontalShiftSpinner
            app.HorizontalShiftSpinner = uispinner(app.UIFigure);
            app.HorizontalShiftSpinner.ValueChangedFcn = createCallbackFcn(app, @HorizontalShiftSpinnerValueChanged, true);
            app.HorizontalShiftSpinner.FontName = 'Arial';
            app.HorizontalShiftSpinner.FontSize = 15;
            app.HorizontalShiftSpinner.Position = [160 43 100 22];

            % Create PhaseShiftdegreesSpinnerLabel
            app.PhaseShiftdegreesSpinnerLabel = uilabel(app.UIFigure);
            app.PhaseShiftdegreesSpinnerLabel.HorizontalAlignment = 'right';
            app.PhaseShiftdegreesSpinnerLabel.FontName = 'Arial';
            app.PhaseShiftdegreesSpinnerLabel.FontSize = 15;
            app.PhaseShiftdegreesSpinnerLabel.Position = [-1 13 146 22];
            app.PhaseShiftdegreesSpinnerLabel.Text = 'Phase Shift(degrees)';

            % Create PhaseShiftdegreesSpinner
            app.PhaseShiftdegreesSpinner = uispinner(app.UIFigure);
            app.PhaseShiftdegreesSpinner.ValueChangedFcn = createCallbackFcn(app, @PhaseShiftdegreesSpinnerValueChanged, true);
            app.PhaseShiftdegreesSpinner.FontName = 'Arial';
            app.PhaseShiftdegreesSpinner.FontSize = 15;
            app.PhaseShiftdegreesSpinner.Position = [160 13 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = FSgenerator

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
