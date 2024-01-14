<?php

/*
 * Copyright (C) 2015-2019 Deciso B.V.
 * Copyright (C) 2024 Cedrik Pischem
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

namespace Pischem\Caddy\FieldTypes;

use OPNsense\Base\FieldTypes\TextField;
use Phalcon\Filter\Validation\Validator\Regex;
use Phalcon\Filter\Validation\Validator\PresenceOf;

/**
 * This is forked from the Base UpdateOnlyTextField. 
 * It hashes passwords with bcrypt before storing them.
 */

/**
 * Class update only TextField (practical for password type fields)
 * @package OPNsense\Base\FieldTypes
 */
class UpdateOnlyBcryptField extends TextField
{
    /**
     * Always return blank
     * @return string
     */
    public function __toString()
    {
        return "";
    }

    /**
     * Update field (if not empty) with bcrypt hash
     * @param string $value
     */
    public function setValue($value)
    {
        if ($value != "") {
            // Hash the value using bcrypt
            $hashedValue = password_hash($value, PASSWORD_BCRYPT);
            parent::setValue($hashedValue);
        }
    }
}
