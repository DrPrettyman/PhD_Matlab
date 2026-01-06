classdef TimeSeries
    %TIMESERIES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        time
        data 
        ACF_windowSize
    end
    
    properties(Access = public, Dependent)
        sACF1
        RBD
    end
    
    properties(Access = private)
        need_to_update_sACF1
        need_to_update_RBD
        cached_sACF1
        cached_RBD
    end
    
    methods
        function self = TimeSeries(vect1, vect2)
            if nargin > 1
                if size(vect1) == size(vect2)
                    self.data = vect2;
                    self.time = vect1;
                else
                    error('times and data vectors must be same size')
                end
            else
                self.data = vect1;
                self.time = (1:size(vect1,1))';
            end
            self.need_to_update_sACF1 = true;
            self.need_to_update_RBD = true;
        end
        
        function self = set.data(self, input)
            self.data = input;
            self.need_to_update_sACF1 = true;
            self.need_to_update_RBD = true;
        end
        
        
        function self = set.ACF_windowSize(self, input)
            self.ACF_windowSize = input;
            self.need_to_update_sACF1 = true;
        end
        
        function r = get.sACF1(self)
            if self.need_to_update_sACF1
                self.cached_sACF1 = ;
            end
            r = self.cached_sACF1;
        end
          
        function r = get.RBD(self)
            if self.need_to_update_RBD
                self.cached_RBD = ;
            end
            r = self.cached_RBD;
        end
        
        function r = plot(self)
            figure
            plot(self.time, self.data)
        end
        
    end
    
    
end

