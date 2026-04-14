import boto3

ec2 = boto3.client('ec2', region_name='us-east-1')
s3 = boto3.client('s3')

def crear_instancias():
    print("Aprovisionando instancias para el sector financiero...")
    # Creamos 2 instancias (respetando el límite de 9 del Lab)
    ec2.run_instances(
        ImageId='ami-0c7217cdde317cfec', 
        MinCount=1, 
        MaxCount=2, 
        InstanceType='t2.micro',
        IamInstanceProfile={'Name': 'LabRole'}
    )
    print("Instancias creadas con éxito.")

def generar_reporte():
    print('--- Reporte de Uso de Recursos ---')
    buckets = s3.list_buckets()['Buckets']
    print(f'Buckets en S3: {len(buckets)}')
    for b in buckets: print(f" - {b['Name']}")

if __name__ == '__main__':
    generar_reporte()
    # crear_instancias() # Descomentar para ejecutar en AWS
