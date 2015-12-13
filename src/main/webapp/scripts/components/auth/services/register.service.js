'use strict';

angular.module('yournewtechApp')
    .factory('Register', function ($resource) {
        return $resource('api/register', {}, {
        });
    });


