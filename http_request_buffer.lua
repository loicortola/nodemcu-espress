return {
 buffer = {},
 isbusy = function(self) return not (next(self.current) == nil) end,
 hasnext = function(self) return not (next(self.buffer) == nil) end,
 current = {},
 remove = function(self, id) self.current[id] = nil self.buffer[id] = nil end,
 push = function(self, element) self.buffer[element.id] = element end,
 next = function(self) local i, e = next(self.buffer) self.current[i] = e self.buffer[i] = nil return e end
}