#include "kernel.h"

int main() {
    char* video_memory = (char*) 0xb8000;
    video_memory[0] = 'O';
    video_memory[1] = 0x0f;
    video_memory[2] = 'K';
    video_memory[3] = 0x0f;
    while(1) {}
    return 0;
}