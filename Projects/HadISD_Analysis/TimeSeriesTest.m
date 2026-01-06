classdef TimeSeriesTest
    %TIMESERIES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        T
        X 
        sliding_ACF1
        stored_windowSize
        
    end
    
    properties(Access = public, Dependent)
        
    end
    
    properties(Access = private)
        need_to_update_sACF1 = true;
    end
    
    methods
        function self = TimeSeries(vect1, vect2)
            if nargin > 1
                if size(vect1) == size(vect2)
                    self.X = vect2;
                    self.T = vect1;
                else
                    error('times and data vectors must be same size')
                end
            else
                self.X = vect1;
                self.T = (1:size(vect1,1))';
            end
        end
        
        function r = sACF1(self, windowSize)
            disp(self.stored_windowSize)
            if windowSize ~= self.stored_windowSize
                self.stored_windowSize = windowSize;
                disp(self.stored_windowSize)
                disp('calulating ACF ...')
                pause(0.5)
                self.sliding_ACF1 = self.X*self.stored_windowSize;
%                 self.sliding_ACF1 = self.stored_windowSize;
            end
            r = self.sliding_ACF1;
        end
            
%         function self = set.sliding_ACF1(self,ws)
%             disp('calculating ACF ...')
%             self.sliding_ACF1 = self.X*ws;
%         end

        function r = get.stored_windowSize(self)
            
        end
        
        
        function r = plot(self)
            figure
            plot(self.T, self.X)
        end
        
    end
    
    
end

