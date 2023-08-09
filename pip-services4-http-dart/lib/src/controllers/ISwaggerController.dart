// Interface to perform Swagger registrations.
abstract interface class ISwaggerController {
  //Perform required Swagger registration steps.
  void registerOpenApiSpec(String? baseRoute, String? swaggerRoute);
}
