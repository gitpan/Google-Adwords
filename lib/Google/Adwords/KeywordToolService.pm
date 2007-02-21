package Google::Adwords::KeywordToolService;
use strict; use warnings;

use version; our $VERSION = qv('0.2');

use base 'Google::Adwords::Service';

# data types
use Google::Adwords::KeywordVariation;
use Google::Adwords::KeywordVariations;
use Google::Adwords::SeedKeyword;
use Google::Adwords::SiteKeyword;
use Google::Adwords::SiteKeywordGroups;

### INSTANCE METHOD ################################################
# Usage      : 
#
#   my $sitekeywordgroups = $obj->getKeywordsFromSite({
#       url     => 'http://url.com',
#       includeLinkedPages => 1,
#       languages   => [ 'en', 'fr' ], 
#       countries   => [ 'IN', 'FR' ]
#   });
#
# Purpose    : Given a URL, returns keywords based on words found on that URL.
# Returns    : A Google::Adwords::SiteKeywordGroups object.
# Parameters : a url, a flag indicating if links should be followed, an array
#  ref of languages, an array ref of countries.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getKeywordsFromSite
{
    my ($self, $args_ref) = @_;

    $args_ref->{languages}	||= [];
    $args_ref->{countries}	||= [];

    my @params;
    push @params, SOAP::Data->name(
        'url' => $args_ref->{url} )->type('');
    push @params, SOAP::Data->name(
      'includeLinkedPages' => ( $args_ref->{includeLinkedPages} ) ? 'true' : 'false' )->type('');
    if ( @{$args_ref->{languages}} ) {
        push @params, SOAP::Data->name(
	        'languages' => @{$args_ref->{languages}} )->type('');
    }
    if ( @{$args_ref->{countries}} ) {
        push @params, SOAP::Data->name(
	        'countries' => @{$args_ref->{countries}} )->type('');
    }


    my $result	= $self->_create_service_and_call({
        service	=> 'KeywordToolService',
        method	=> 'getKeywordsFromSite',
        params	=> \@params,
    });

    # get response data in a hash
    my $data = $result->valueof("//getKeywordsFromSiteResponse/getKeywordsFromSiteReturn");

    my $sitekeywordgroups = Google::Adwords::SiteKeywordGroups->new();
    $sitekeywordgroups->groups($data->{groups});

    my @keywords;
    if ($data->{keywords}) {
        for ( @{$data->{keywords}} ) {
            push @keywords, 
	            $self->_create_object_from_hash($_, 'Google::Adwords::SiteKeyword');
        }
        $sitekeywordgroups->keywords(@keywords);
    }

    return $sitekeywordgroups;
}


### INSTANCE METHOD ################################################
# Usage      : 
#
#   my $keyword_variations = $obj->getKeywordVariations({
#       seedKeywords => \@seedkeyword, 
#       useSynonyms => 1, 
#       languages  => \@languages, 
#       countries  => \@countries
#   });
#
# Purpose    : Given a list of SeedKeyword objects, returns their 
#  variations in multiple lists.
# Returns    : A Google::Adwords::KeywordVariations object.
# Parameters : an array ref of Google::Adwords::SeedKeyword objects, a flag
#  indicating if synonyms are enabled, an array ref of languages, 
#  an array ref of countries.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getKeywordVariations
{
    my ($self, $args_ref) = @_;

    $args_ref->{seedKeywords} ||= [];
    $args_ref->{useSynonyms} ||= 0;
    $args_ref->{languages} ||= [];
    $args_ref->{countries} ||= [];

    my @params;

    for (@{$args_ref->{seedKeywords}}) {
        my @seedkeyword;
        if ( defined $_->negative ) {
            push @seedkeyword, SOAP::Data->name(
                'negative' => ( $_->negative ) ? 'true' : 'false' )->type('');
        }
        if ( defined $_->text ) {
            push @seedkeyword, SOAP::Data->name(
                'text' => $_->text )->type('');
        }
        if ( defined $_->type ) {
            push @seedkeyword, SOAP::Data->name(
                'type' => $_->type )->type('');
        }
        push @params, SOAP::Data->name(
	        'seedKeywords' => \SOAP::Data->value(@seedkeyword) )->type('');
    }

    push @params, SOAP::Data->name(
        'useSynonyms' => ( $args_ref->{useSynonyms} ) ? 'true' : 'false' )->type('');

    if ( @{$args_ref->{languages}} ) {
        push @params, SOAP::Data->name(
	        'languages' => @{$args_ref->{languages}} )->type('');
    }
    if ( @{$args_ref->{countries}} ) {
        push @params, SOAP::Data->name(
	        'countries' => @{$args_ref->{countries}} )->type('');
    }


    my $result	= $self->_create_service_and_call({
        service	=> 'KeywordToolService',
        method	=> 'getKeywordVariations',
        params	=> \@params,
    });

    # get response data in a hash
    my $data = $result->valueof("//getKeywordVariationsResponse/getKeywordVariationsReturn");

    my $keyword_variations = Google::Adwords::KeywordVariations->new();

    my @additionalToConsider;
    if ( $data->{additionalToConsider} ) {
        for ( @{$data->{additionalToConsider}} ) {
            push @additionalToConsider, 
	            $self->_create_object_from_hash($_, 'Google::Adwords::KeywordVariation');
        }
        $keyword_variations->additionalToConsider(@additionalToConsider);
    }
    
    my @moreSpecific;
    if ( $data->{moreSpecific} ) {
        for ( @{ $data->{moreSpecific} } ) {
            push @moreSpecific, 
	            $self->_create_object_from_hash($_, 'Google::Adwords::KeywordVariation');
        }
        $keyword_variations->moreSpecific(@moreSpecific);
    }

    return $keyword_variations;
}
    

1;

=pod

=head1 NAME
 
Google::Adwords::KeywordToolService - Interact with the Google Adwords
KeywordToolService API calls
 
 
=head1 VERSION

This documentation refers to Google::Adwords::KeywordToolService version 0.2
 
 
=head1 SYNOPSIS

    use Google::Adwords::KeywordToolService;
    use Google::Adwords::SeedKeyword;

    # create the keyword tool service object
    my $kwtool_service = Google::Adwords::KeywordToolService->new();

    # need to login to the Adwords service
    $kwtool_service->email($email_address)
                    ->password($password)
                    ->developerToken($developer_token)
                    ->applicationToken($app_token);

    # if you have a MCC
    $kwtool_service->clientEmail($client_email);

    # getKeywordsFromSite
    my $sitekeywordgroups = $kwtool_service->getKeywordsFromSite({
        url                 => 'http://url.com',
        includeLinkedPages  => 1,
        languages           =>  [ 'en', 'fr' ],
        countries           => [ 'IN', 'FR' ]
    });;

    print "Groups : " . join('|', @{$sitekeywordgroups->groups}) ."\n";
    for ( @{$sitekeywordgroups->keywords} ) {
      print "Keyword # text : " . $_->text . " | searchVolumeScale : " . $_->searchVolumeScale ."\n";
    }

    # getKeywordVariations
    my $seed1 = Google::Adwords::SeedKeyword->new
    			    ->text('world news')
			        ->type('Broad');
    my $seed2 = Google::Adwords::SeedKeyword->new
    			    ->text('independant news')
			        ->type('Broad');

    my $keyword_variations = $kwtool_service->getKeywordVariations({
           seedKeywords => [ $seed1, $seed2, ],
           useSynonyms => 1,
           languages  => [ 'en', 'fr', ],
           countries  => [ 'US', 'IN', ],
    });

    print "additionalToConsider \n";
    for ( @{$keyword_variations->additionalToConsider} ) {
     print "Keyword # text : " . $_->text . " | searchVolumeScale : " . $_->searchVolumeScale . "\n";
    }
    print "moreSpecific \n";
    for ( @{$keyword_variations->moreSpecific} ) {
     print "Keyword # text : " . $_->text . " | searchVolumeScale : " . $_->searchVolumeScale . "\n";
    }
 
  
=head1 DESCRIPTION

This module provides an interface to the Google Adwords KeywordToolService API
calls. 

  
=head1 METHODS 

=head2 B<getKeywordsFromSite()>

=head3 Description

=over 4

Given a URL, returns keywords based on words found on that web page or site, which
can be used as keyword criteria for a campaign. The results are grouped by common
keywords, with the groups ordered by decreasing relevance.

=back

=head3 Usage

    my $sitekeywordgroups = $service->getKeywordsFromSite({
        url                 => 'http://url.com',
        includeLinkedPages  => 1,
        languages           =>  [ 'en', 'fr' ],
        countries           => [ 'IN', 'FR' ]
    });;


=head3 Parameters

Takes a hashref with following keys:

=over 4

=item * url =>  the site's location.

=item * includeLinkedPages =>  whether to follow links on the page at the given url

=item * languages => arrayref of language codes

=item * countries => arrayref of country codes

=back

=head3 Returns
 
=over 4

A Google::Adwords::SiteKeywordGroups object.

=back

=head2 B<getKeywordVariations()>

=head3 Description

=over 4

Given a list of SeedKeywords, returns their variations in multiple lists within
KeywordVariations. Each list represents a different kind of variation.

=back

=head3 Usage

    my $keyword_variations = $service->getKeywordVariations({
           seedKeywords => [ $seed1, $seed2, ],
           useSynonyms => 1,
           languages  => [ 'en', 'fr', ],
           countries  => [ 'US', 'IN', ],
    });

=head3 Parameters

Takes a hashref with following keys:

=over 4

=item * seedkeyword => an array ref of Google::Adwords::SeedKeyword objects

=item * useSynonyms  => if set to 1, will use synonyms of source keywords as sources.

=item * languages => arrayref of language codes

=item * countries => arrayref of country codes

=back

=head3 Returns
 
=over 4

A Google::Adwords::KeywordVariations object.

=back


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::SeedKeyword>

=item * L<Google::Adwords::SiteKeywordGroups>

=item * L<Google::Adwords::SiteKeyword>

=item * L<Google::Adwords::KeywordVariations>

=item * L<Google::Adwords::KeywordVariation>

=back

=head1 AUTHORS
 
Rohan Almeida <rohan@almeida.in>
 
Mathieu Jondet <mathieu@eulerian.com>
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

