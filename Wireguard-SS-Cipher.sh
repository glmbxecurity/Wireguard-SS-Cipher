#!/bin/sh
clear
BASE_DIR="./wg_secure_configs"
DICT_FILE="./diccionario.txt"

# Mostrar instrucciones al inicio
echo "============================================="
echo "🔐 	   Wireguard-SS-Cipher"
echo "============================================="
echo ""
echo "Este script permite seleccionar un túnel existente y cifrar"
echo "la clave privada contenida dentro de un archivo .conf de cliente"
echo "usando GPG con una passphrase generada desde un diccionario."
echo ""
echo "✅ Se genera:"
echo " - nombre.key.gpg 	 (clave privada cifrada)"
echo " - nombre.pass   	   	(passphrase para descifrado)"
echo " - nombre_secured.conf 	(configuración con clave sustituida)"
echo ""
echo "📁 Estructura esperada:"
echo " - ./wg_secure_configs/NOMBRE_TUNEL/clients/*.conf"
echo ""
echo "============================================="
echo ""

# Validar diccionario
if [ ! -f "$DICT_FILE" ]; then
    echo "❌ No se encontró el diccionario: $DICT_FILE"
    exit 1
fi

generate_passphrase() {
    pass=""
    while [ ${#pass} -lt 20 ]; do
        word=$(awk -v var=$((RANDOM % $(wc -l < "$DICT_FILE"))) 'NR == var {print $0}' "$DICT_FILE")
        pass="$pass$word"
    done
    echo "$pass"
}

select_tunnel() {
    echo "📂 Túneles disponibles:"
    tunnels=("$BASE_DIR"/*)
    count=1
    for dir in "${tunnels[@]}"; do
        echo "$count) $(basename "$dir")"
        count=$((count + 1))
    done

    read -p "Selecciona el número del túnel: " tunnel_choice
    TUNNEL_NAME=$(basename "${tunnels[$((tunnel_choice - 1))]}")
    CLIENT_DIR="$BASE_DIR/$TUNNEL_NAME/clients"

    if [ ! -d "$CLIENT_DIR" ]; then
        echo "❌ No se encontró el directorio de clientes: $CLIENT_DIR"
        exit 1
    fi
}

select_client() {
    echo "👥 Archivos de configuración disponibles en $TUNNEL_NAME:"
    clients=("$CLIENT_DIR"/*.conf)
    count=1
    for conf in "${clients[@]}"; do
        echo "$count) $(basename "$conf")"
        count=$((count + 1))
    done

    read -p "Selecciona el número del archivo que quieres cifrar: " client_choice
    CLIENT_CONF="${clients[$((client_choice - 1))]}"
    CLIENT_BASENAME=$(basename "$CLIENT_CONF" .conf)
    ENCRYPTED_KEY="$CLIENT_DIR/$CLIENT_BASENAME.key.gpg"
    PASSPHRASE_FILE="$CLIENT_DIR/$CLIENT_BASENAME.pass"
    SECURED_CONF="$CLIENT_DIR/$CLIENT_BASENAME.secured.conf"

    # Extraer clave privada desde el archivo de configuración
    CLIENT_PRIV_KEY=$(awk '/PrivateKey/ {print $3}' "$CLIENT_CONF")

    if [ -z "$CLIENT_PRIV_KEY" ]; then
        echo "❌ No se encontró la clave privada en $CLIENT_CONF"
        exit 1
    fi

    if [ -f "$ENCRYPTED_KEY" ]; then
        echo "⚠️  Ya existe un archivo cifrado para $CLIENT_BASENAME. ¿Sobrescribir?"
        read -p "(s/n): " overwrite
        if [ "$overwrite" != "s" ]; then
            echo "🚫 Operación cancelada."
            exit 0
        fi
    fi
}

encrypt_client_key() {
    PASSPHRASE=$(generate_passphrase)
    echo "$PASSPHRASE" > "$PASSPHRASE_FILE"

    TMP_KEY_FILE=$(mktemp)
    echo "$CLIENT_PRIV_KEY" > "$TMP_KEY_FILE"

    gpg --symmetric --batch --yes --pinentry-mode loopback \
        --passphrase "$PASSPHRASE" \
        -o "$ENCRYPTED_KEY" "$TMP_KEY_FILE"

    rm -f "$TMP_KEY_FILE"

    echo "✅ Clave privada cifrada guardada como: $ENCRYPTED_KEY"
    echo "🔑 Passphrase almacenada en: $PASSPHRASE_FILE"
}

create_secured_conf() {
    sed 's/^PrivateKey = .*/PrivateKey = __REPLACE_WITH_DECRYPTED_KEY__/' "$CLIENT_CONF" > "$SECURED_CONF"
    echo "📄 Archivo de configuración seguro creado: $SECURED_CONF"
}

# Flujo principal
select_tunnel
select_client
encrypt_client_key
create_secured_conf

