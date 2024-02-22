const std = @import("std");

pub const MLModelTypes = enum {
    LSTM,
    RNN,
    Transformer,

    const longNames = [@typeInfo(MLModelTypes).Enum.fields.len][:0]const u8{ "Transformer Model", "Recurrent Neural Network", "Long Short Term Memory" };

    pub fn longName(self: MLModelTypes) [:0]const u8 {
        return longNames[@intFromEnum(self)];
    }

    pub fn printAllValues() void {
        inline for (@typeInfo(MLModelTypes).Enum.fields) |f| {
            std.debug.print("{d} {s}: {s}\n", .{ f.value, f.name, longName(@enumFromInt(f.value)) });
        }
    }
};

pub const NLPModelTypes = enum {
    BERT,
    GPT,
    LSTM,

    const longNames = [@typeInfo(NLPModelTypes).Enum.fields.len][:0]const u8{ "Generative Pre-Trained Transformers", "Bidirectional Encoder Representation From Transformers", "Long Short-Term Memory" };

    pub fn longName(self: NLPModelTypes) [:0]const u8 {
        return longNames[@intFromEnum(self)];
    }
};

pub fn demo() !void {
    MLModelTypes.printAllValues();

    var modelType: NLPModelTypes = .GPT;
    std.debug.print("{s}\n", .{modelType.longName()});
}
