//
// Created with the ESP Memory Generator
//
// Copyright (c) 2011-2019 Columbia University, System Level Design Group
// SPDX-License-Identifier: Apache-2.0
//
// @author Paolo Mantovani <paolo@cs.columbia.edu>
//

#ifndef __HL5_BLOCK_1W1R_HPP__
#define __HL5_BLOCK_1W1R_HPP__
#include "hl5_block_1w1r.h"
template<class T, unsigned S, typename ioConfig=CYN::PIN>
class hl5_block_1w1r_t : public sc_module
{

  HLS_INLINE_MODULE;
public:
  hl5_block_1w1r_t(const sc_module_name& name = sc_gen_unique_name("hl5_block_1w1r"))
  : sc_module(name)
  , clk("clk")
  , port1("port1")
  , port2("port2")
  {
    m_m0.clk_rst(clk);
    port1(m_m0.if1);
    port2(m_m0.if2);
  }

  sc_in<bool> clk;

  hl5_block_1w1r::wrapper<ioConfig> m_m0;

  typedef hl5_block_1w1r::port_1<ioConfig, T[1][S]> Port1_t;
  typedef hl5_block_1w1r::port_2<ioConfig, T[1][S]> Port2_t;

  Port1_t port1;
  Port2_t port2;
};
#endif
