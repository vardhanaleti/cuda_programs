#include<stdio.h>
#include<cuda_runtime.h>
#include"device_launch_parameters.h"
//kernel definition
__global__ void increment_gpu(int* a, int* b, int* c, int N)
{
	int i = blockIdx.x;
	if (i < N)
		c[i] = a[i] + b[i];
}

int main()
{
	int n;
	printf("Enter n\n");
	scanf("%d", &n);
	int N = n;
	int h1_a[100], h2_a[100];
	//int h2_a[5] = { 10,20,30,40,50 };
	int h3_a[100] = { 0 };

	printf("Enter the 1st array\n");
	for (int i = 0; i < n; i++)
		scanf("%d", &h1_a[i]);
	printf("Enter the 2nd array\n");
	for(int i = 0; i < n; i++)
		scanf("%d", &h2_a[i]);
	int* d1_a;
	int* d2_a;
	int* d3_a;
	cudaMalloc((void**)&d1_a, N * sizeof(int));
	cudaMalloc((void**)&d2_a, N * sizeof(int));
	cudaMalloc((void**)&d3_a, N * sizeof(int));
	cudaMemcpy(d1_a, h1_a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d2_a, h2_a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d3_a, h3_a, N * sizeof(int), cudaMemcpyHostToDevice);

	dim3 grid_size(N);
	dim3 block_size(1);

	increment_gpu <<<grid_size, block_size>>>(d1_a, d2_a, d3_a, N);

	cudaMemcpy(h3_a, d3_a, N * sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(d1_a);
	cudaFree(d2_a);
	cudaFree(d3_a);
	for (int i = 0; i < N; i++)
	{
		printf("%d ", h3_a[i]);
	}
	return 0;
}