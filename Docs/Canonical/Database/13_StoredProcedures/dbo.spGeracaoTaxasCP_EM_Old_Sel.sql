SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGeracaoTaxasCP_EM_Old_Sel]--'EMCSR201505031BR'

@Num_Proc	Varchar(16)
AS

Declare @Grupo	Varchar(10)

if upper(left(@num_proc,2))='EM'
	BEGIN
insert CtA_cte_hou_exp_mar
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc and HOU.Cd_Export_HEM = CP.Cd_Cliente					
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
				
			Where
					id_status_cp='1'
					and Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'
		Union all
			
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc	and HOU.Cd_Export_HEM = CP.Cd_Cliente					
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
	
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='A'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'
		Union all
		
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc		and HOU.Cd_Export_HEM = CP.Cd_Cliente				
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
		
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='C'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'	


			--Tarifas Gerais por Modal						
--			Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
			
--			Insert CtA_cte_hou_exp_mar
insert CtA_cte_hou_exp_mar										
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc						
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
					join Pessoa_LLP PL on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 				
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA

insert CtA_cte_hou_exp_mar										
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc						
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
					join Pessoa_LLP PL on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 				
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA

insert CtA_cte_hou_exp_mar										
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc						
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
					join Pessoa_LLP PL on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente					
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
		Union all
			
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc						
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
					join Pessoa_LLP PL on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente			
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='A'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'
		Union all
		
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hem='C'		
					Join House_exp_Mar hou on hou.num_proc_hem=@Num_Proc						
					Join LLP_exp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lem=@Num_Proc
					join Pessoa_LLP PL on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente			
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hem is null
					and CP.Cd_Tipo_Servico='C'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EM'	
END
GO
