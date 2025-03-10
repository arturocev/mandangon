import 'package:flutter/material.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _showChangePassword = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _toggleChangePassword() {
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _showChangePassword = !_showChangePassword;
    });
  }

  void _confirmPasswordChange() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword.length < 8 || newPassword.length > 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("La contraseña debe tener entre 8 y 12 caracteres.")),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contraseña actualizada con éxito.")),
    );
    _toggleChangePassword();
  }

  void _showTermsAndPrivacy(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
            child: Text(content, textAlign: TextAlign.justify)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Ajustes"),
      ),
      body: _showChangePassword
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Escribe la nueva contraseña",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirmar nueva contraseña",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _confirmPasswordChange,
                    child: const Text("Confirmar"),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.orange),
                  title: const Text("Cambiar contraseña"),
                  onTap: _toggleChangePassword,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.article, color: Colors.green),
                  title: const Text("Términos de la empresa"),
                  onTap: () {
                    _showTermsAndPrivacy(
                      "Términos de la empresa",
                      "Última actualización: [06/03/2025]\n"
                          "Bienvenido a Mandangon. Antes de utilizar nuestros servicios, te pedimos que leas y aceptes los siguientes términos y condiciones\n"
                          "1. Definiciones\n"
                          "- Plataforma: Aplicación móvil y web de Mandangon que permite a los usuarios acceder a recetas y localizar restaurantes cercanos.\n"
                          "- Usuario: Persona que utiliza la plataforma para visualizar recetas o encontrar restaurantes.\n"
                          "- Restaurante asociado: Establecimiento que proporciona información sobre su ubicación, contacto y servicios.\n"
                          "2. Uso de la Plataforma\n"
                          "- Se prohíbe el uso de la plataforma para actividades fraudulentas o ilegales.\n"
                          "- Mandangon no es responsable de la disponibilidad o calidad de los productos de los restaurantes ni de los ingredientes de las recetas.\n"
                          "3. Recetas\n"
                          "- Cada receta incluye una imagen, una lista de ingredientes y pasos detallados de preparación.\n"
                          "- La información proporcionada es orientativa y puede variar según los ingredientes o la preparación.\n"
                          "- [Mandangon] no se responsabiliza por alergias o problemas de salud derivados del consumo de los platos preparados.\n"
                          "4. Restaurantes Cercanos\n"
                          "- La plataforma muestra restaurantes basados en la ubicación del usuario.\n"
                          "- Cada restaurante puede incluir información como dirección, teléfono, horario y servicios disponibles.\n"
                          "- Mandangon no garantiza la exactitud de la información ni la disponibilidad de los servicios en los restaurantes listados.\n"
                          "5. Responsabilidad y Limitaciones\n"
                          "- Mandangon actúa como intermediario y no es responsable por problemas en la información de recetas o restaurantes.\n"
                          "- No garantizamos la disponibilidad constante de la plataforma y nos reservamos el derecho de modificar o suspender servicios en cualquier momento.\n"
                          "6. Modificaciones de los Términos\n"
                          "- Nos reservamos el derecho de modificar estos términos cuando sea necesario.\n"
                          "- El uso continuado de la plataforma después de los cambios implica la aceptación de los nuevos términos.\n"
                          "Si tienes dudas, contáctanos en soporte@mandangon.com.",
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip, color: Colors.blue),
                  title: const Text("Política de privacidad"),
                  onTap: () {
                    _showTermsAndPrivacy(
                      "Política de privacidad",
                      "Última actualización: [06/03/2025]\n"
                          "En Mandangon, nos tomamos muy en serio la privacidad de nuestros usuarios. Esta Política de Privacidad describe cómo recopilamos, usamos y protegemos tu información personal cuando utilizas nuestra aplicación.\n"
                          "1. Información que Recopilamos\n"
                          "- Información personal: Nombre, correo electrónico, teléfono (si decides registrarte).\n"
                          "- Datos de uso: Información sobre cómo interactúas con la aplicación, como recetas consultadas o restaurantes visitados.\n"
                          "2. Uso de la Información\n"
                          "- Ofrecerte una mejor experiencia, permitiéndote acceder a recetas y restaurantes cercanos de manera personalizada.\n"
                          "- Mejorar nuestra plataforma mediante análisis del comportamiento de los usuarios.\n"
                          "- Enviarte notificaciones sobre actualizaciones o promociones (si decides aceptarlas).\n"
                          "3. Compartición de Datos\n"
                          "- No vendemos ni compartimos tu información personal con terceros, salvo en los siguientes casos:\n"
                          "  - Con proveedores de servicios que nos ayudan a operar la plataforma (por ejemplo, servidores de almacenamiento).\n"
                          "  - Si es requerido por ley o por una solicitud legal válida.\n"
                          "4. Seguridad de la Información\n"
                          "- Implementamos medidas de seguridad para proteger tu información, pero no podemos garantizar una seguridad absoluta. Se recomienda no compartir datos sensibles en la plataforma.\n"
                          "5. Permisos y Control de Datos\n"
                          "- Puedes gestionar los permisos otorgados a la aplicación en los ajustes de tu dispositivo. También puedes:\n"
                          "  - Modificar o eliminar tu cuenta en cualquier momento.\n"
                          "  - Desactivar el acceso a la ubicación desde los ajustes del teléfono.\n"
                          "  - Solicitar la eliminación de tus datos contactándonos en [soporte@mandangon.com].\n"
                          "6. Cambios en la Política de Privacidad\n"
                          "- Nos reservamos el derecho de modificar esta política en cualquier momento. Te notificaremos sobre cambios importantes a través de la aplicación.\n"
                          "Si tienes dudas, contáctanos en soporte@mandangon.com.",
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Eliminar cuenta",
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirmar eliminación"),
                        content: const Text(
                            "¿Estás seguro que quieres eliminar la cuenta?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Cuenta eliminada")),
                              );
                            },
                            child: const Text("Confirmar"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.blue),
                  title: const Text("Cerrar sesión"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Se ha cerrado la sesión")),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
