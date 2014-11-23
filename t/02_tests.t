#!/usr/bin/env perl

use Test::More;
use AWS::Networks;

use File::Slurp;
use JSON;

my $json = read_file('t/02_test.json');
my $net = AWS::Networks->new(
  netinfo => decode_json($json)  
);

is_deeply(
  [ sort @{ $net->regions } ],
  [ sort qw/ap-northeast-1 ap-southeast-1 ap-southeast-2 cn-north-1 eu-central-1 eu-west-1 sa-east-1 us-east-1 us-gov-west-1 us-west-1 us-west-2 GLOBAL/ ],
  'Regions OK'
);

is_deeply(
  [ sort @{ $net->services } ],
  [ sort qw/AMAZON EC2 CLOUDFRONT ROUTE53 ROUTE53_HEALTHCHECKS/],
  'Services OK'
);

is_deeply(
  [ sort @{ $net->by_region('GLOBAL')->services } ],
  [ sort (
          'CLOUDFRONT',
          'ROUTE53',
          'AMAZON'
  ) ],
  'Global region services'
);

is_deeply(
  [ sort @{ $net->by_service('EC2')->regions } ],
  [ sort (
          'ap-northeast-1',
          'ap-southeast-2',
          'us-gov-west-1',
          'sa-east-1',
          'eu-west-1',
          'eu-central-1',
          'us-west-1',
          'us-west-2',
          'us-east-1',
          'ap-southeast-1',
          'cn-north-1'
        )
  ],
  'EC2 Regions'
);

is_deeply(
  [ sort @{ $net->by_service('ROUTE53')->regions } ],
  [ 'GLOBAL' ],
  'Route53 regions'
);

done_testing;
