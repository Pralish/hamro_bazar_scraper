export class ApiResponse<T> {
  success: boolean;
  data: T;
  message: string;
}
