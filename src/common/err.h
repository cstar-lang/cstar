#ifndef __ERR_H__
#define __ERR_H__

#define _ERR(format, ...) { fprintf(stderr, format, ##__VA_ARGS__); exit(1); }
