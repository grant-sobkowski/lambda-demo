

# https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html#python-handler-how
def lambda_handler(event: dict, context: dict) -> str: 
    """lambda handler function which greets user

    Args:
        event (dict): The event dict object passed to the lambda function.
        context (dict): Provides information about the invocation, function, and runtime environment.

    Returns:
        message (str): The return value. True for success, False otherwise.

    Example event data: 
    {
        "first_name": "John",
        "last_name": "Smith"
    }

    """
    first_name = event['first_name']
    last_name = event['last_name']
    message = f'Hello {first_name} {last_name}'
    return { 
        'message' : message
    }