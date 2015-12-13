 'use strict';

angular.module('yournewtechApp')
    .factory('notificationInterceptor', function ($q, AlertService) {
        return {
            response: function(response) {
                var alertKey = response.headers('X-yournewtechApp-alert');
                if (angular.isString(alertKey)) {
                    AlertService.success(alertKey, { param : response.headers('X-yournewtechApp-params')});
                }
                return response;
            }
        };
    });
