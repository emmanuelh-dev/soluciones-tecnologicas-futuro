import os

import boto3
from botocore.exceptions import ClientError


REGION_NAME = os.environ.get('AWS_REGION', 'us-east-1')


def get_s3_inventory(region: str):
    """Muestra el inventario de buckets S3."""
    try:
        s3 = boto3.client('s3', region_name=region)
        print('--- Inventario de Buckets S3 ---')

        response = s3.list_buckets()

        if response['Buckets']:
            for bucket in response['Buckets']:
                print(f'Bucket: {bucket["Name"]}')
        else:
            print('No se encontraron buckets S3.')

    except ClientError as e:
        print(f'Error de AWS al acceder a S3: {e}')
    except Exception as e:
        print(f'Ocurrió un error inesperado: {e}')


def get_ec2_status(region: str):
    """Muestra el estado de todas las instancias EC2."""
    try:
        ec2 = boto3.resource('ec2', region_name=region)
        print('\n--- Estado de Instancias EC2 ---')

        instances = list(ec2.instances.all())

        if instances:
            for instance in instances:
                print(f'ID: {instance.id}, Estado: {instance.state["Name"]}, Tipo: {instance.instance_type}')
        else:
            print('No se encontraron instancias EC2.')

    except ClientError as e:
        print(f'Error de AWS al acceder a EC2: {e}')
    except Exception as e:
        print(f'Ocurrió un error inesperado: {e}')


def manage_aws():
    """Función principal para gestionar los recursos de AWS."""
    print(f'Ejecutando inventario en la región: {REGION_NAME}')
    get_s3_inventory(REGION_NAME)
    get_ec2_status(REGION_NAME)


if __name__ == '__main__':
    manage_aws()
