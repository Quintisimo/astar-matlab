classdef node
    properties
       parent = [];
       position;
       g = 0;
       h = 0;
    end
    
    methods
        function obj = node(position, parent, g, h)
            obj.position = position;
            obj.parent = parent;
            obj.g = g;
            obj.h = h;
        end
        
        function is_eq = eq(self, other)
            is_eq = isequal(self.position, other.position);
        end
        
        function not_eq = ne(self, other)
            not_eq = ~isequal(self.position, other.position);
        end
        
        function g = ge(self, other)
            self_f = self.g + self.h;
            other_f = other.g + other.h;
            g = self_f >= other_f;
        end
        
        function l = lt(self, other)
            self_f = self.g + self.h;
            other_f = other.g + other.h;
            l = self_f < other_f;
        end
    end
end