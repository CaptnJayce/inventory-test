package main

import "core:fmt"
import rl "vendor:raylib"

SLOT_SIZE :: 60
INVENTORY_COLUMNS :: 5
INVENTORY_ROWS :: 10 
TOTAL_SLOTS :: INVENTORY_ROWS * INVENTORY_COLUMNS

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 720

ItemType :: enum {
    None,
    Berry,
    Crystal,
    Pebble,
}

ItemStack :: struct {
    item: ItemType,
    count: int,
}

Inventory :: struct {
    slots:[TOTAL_SLOTS]ItemStack, 
}

i: Inventory

init_inventory :: proc() {
    i.slots[0] = ItemStack{.Berry, 0}
    i.slots[4] = ItemStack{.Crystal, 0}
    i.slots[8] = ItemStack{.Pebble, 0}
}

draw_inventory :: proc() {
    total_length : i32  = INVENTORY_COLUMNS * SLOT_SIZE 
    offset_x : i32 = (SCREEN_WIDTH / 2) - (total_length / 2)
    offset_y : i32 = 40 

    draw_at_x : i32 = offset_x 
    draw_at_y : i32 = offset_y

    for idx in 0..<TOTAL_SLOTS {
        rl.DrawRectangleLines(draw_at_x, draw_at_y, SLOT_SIZE, SLOT_SIZE, rl.WHITE)

        item_stack := i.slots[idx]
        if item_stack.item != .None {
            #partial switch item_stack.item {
            case .Berry:
                rl.DrawRectangle(draw_at_x, draw_at_y, 20, 20, rl.RED)
                rl.DrawText(rl.TextFormat("%d", item_stack.count), draw_at_x, draw_at_y, 20, rl.WHITE)
            case .Crystal:
                rl.DrawRectangle(draw_at_x, draw_at_y, 20, 20, rl.BLUE)
                rl.DrawText(rl.TextFormat("%d", item_stack.count), draw_at_x, draw_at_y, 20, rl.WHITE)
            case .Pebble:
                rl.DrawRectangle(draw_at_x, draw_at_y, 20, 20, rl.GRAY)
                rl.DrawText(rl.TextFormat("%d", item_stack.count), draw_at_x, draw_at_y, 20, rl.WHITE)
            }
        }

        draw_at_x += SLOT_SIZE 

        if draw_at_x == (offset_x + (INVENTORY_COLUMNS * SLOT_SIZE)) {
            draw_at_x = offset_x
            draw_at_y += SLOT_SIZE 
        }
    }
}

add_item :: proc() {
    // replace IsKeyPressed with collisions in actual game
    if rl.IsKeyPressed(.B) { i.slots[0].count += 1 }    
    if rl.IsKeyPressed(.C) { i.slots[4].count += 1 }    
    if rl.IsKeyPressed(.P) { i.slots[8].count += 1 }    
}

main :: proc() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "inventory")
    defer rl.CloseWindow()

    init_inventory()

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()

        add_item()
        draw_inventory()
        // rl.DrawLine(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT, rl.RED) // draw line at centre of screen

        rl.ClearBackground(rl.BLACK)
    }
}
