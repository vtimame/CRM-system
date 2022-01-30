@component('mail::message')
    # Ваш новый пин-код:
    @component('mail::panel')
        {{ $password }}
    @endcomponent
@endcomponent
