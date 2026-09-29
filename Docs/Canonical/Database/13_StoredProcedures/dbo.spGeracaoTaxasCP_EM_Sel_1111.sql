SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGeracaoTaxasCP_EM_Sel_1111] --'IMFMC201408049BR'
		@Num_Proc	Varchar(16)
AS


Begin /**Cria Por Cliente**/

	Begin /**Destino ALL**/
	
		INSERT Cta_Cte_Hou_Exp_Mar
			
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.num_proc_hem=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.num_proc_hem=@Num_Proc and  Cd_Export_HEM=cd_cliente and CP.Cd_Org = HOU.Cd_Org_HEM
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hem is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'		

			--Inspeção de Madeira nao tem
			--Emissão de LI  nao tem				
			--LI SUB   nao tem
					
		UNION ALL
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEM),convert(varchar(10),getdatE(),103),Cd_Export_HEM,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc 	and  Cd_Export_HEM=cd_cliente and CP.Cd_Org = HOU.Cd_Org_HEM					
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
				Join PO_HEM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEM = @Num_Proc	
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA
	
		UNION ALL
			--Documento
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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc and  Cd_Export_HEM=cd_cliente and CP.Cd_Org = HOU.Cd_Org_HEM			
				Join LLP_Exp_Mar LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx not in ('ECO')

	End /**Origem ALL**/
	
	Begin /**Origem and Destino ALL**/
	
		INSERT Cta_Cte_Hou_Exp_Mar
		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEM,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc and Cd_Export_HEM=cd_cliente
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga and Num_Proc_Lem=@num_proc	
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'
				
			--Inspeção de Madeira			
			--Emissão de LI				
			--LI SUB
				
		UNION ALL
		
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEM),convert(varchar(10),getdatE(),103),Cd_Export_HEM,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc and Cd_Export_HEM=cd_cliente					
				Join LLP_Exp_Mar LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
				Join PO_HEM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEM = @Num_Proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA

		UNION ALL

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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc and Cd_Export_HEM=cd_cliente			
				Join LLP_Exp_Mar LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL' and Cp.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx not in ('ECO')
				
	End /**Origem and Destino ALL**/
	
End /**Cria Por Cliente**/



Begin /**Cria Por Grupo*/

	Begin /**Destino ALL**/
	
		INSERT Cta_Cte_Hou_Exp_Mar
		
			--Inspeção de Madeira			
			--Emissão de LI		
			--LI SUB			
		
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEM),convert(varchar(10),getdatE(),103),Cd_Export_HEM,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc and CP.Cd_Org = HOU.Cd_Org_HEM						
				Join LLP_Exp_Mar LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
				Join PO_HEM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEM = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA

		UNION ALL

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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc and CP.Cd_Org = HOU.Cd_Org_HEM						
				Join LLP_Exp_Mar LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx not in ('ECO')
	
		UNION ALL
		
			--Serviços Prestados - SAMPLE
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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc and CP.Cd_Org = HOU.Cd_Org_HEM
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'		
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'							
				and CPT.Cd_Tp_Tx = 'SR2'
			group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA

		UNION ALL
		
			--Serviços Prestados - PO		
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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc and CP.Cd_Org = HOU.Cd_Org_HEM
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo  <> '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'		
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'							
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA
				
		UNION ALL
		
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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc and CP.Cd_Org = HOU.Cd_Org_HEM
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'		
				AND (CP.Cd_Dst='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem ALL**/
	
	Begin /**Origem and Destino ALL**/
		
		INSERT Cta_Cte_Hou_Exp_Mar
		
			--Inspeção de Madeira			
			--Emissão de LI		
			--LI SUB		
		
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEM),convert(varchar(10),getdatE(),103),Cd_Export_HEM,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc					
				Join LLP_Exp_Mar LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
				Join PO_HEM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEM = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA
				
		UNION ALL

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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@num_proc					
				Join LLP_Exp_Mar LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EM'
				and CPT.Cd_Tp_Tx not in ('ECO')				
				
		UNION ALL
	
			--Serviços Prestados - SAMPLE
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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 				
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'							
				and CPT.Cd_Tp_Tx = 'SR2'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA

		UNION ALL
			
			--Serviços Prestados - PO		
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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo  <> '4' 
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'
				AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'							
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEM,IVA
					
		UNION ALL
		
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
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
				Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc
				Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEM is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EM'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem and Destino ALL**/
	
End /**Cria Por Grupo*/

Begin /**Regras Gerais**/

	insert Cta_Cte_Hou_Imp_Mar
	
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
			Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
			Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
			Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc
			Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
			join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente					
		Where
			id_status_cp='1'
			And Cd_Tipo_Venda='J'
			and cta.Num_Proc_HEM is null
			and CP.Cd_Tipo_Servico='A'
			AND (Cp.Cd_Dst='ALL' and Cp.Cd_Org='ALL')
			and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
			and Modal='EM'
			
	UNION ALL
						
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
			Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
			Left Join Cta_Cte_Hou_Exp_Mar CTA with(nolock) on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
			Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=@Num_Proc
			Join LLP_Exp_Mar LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and Num_Proc_Lem=@num_proc	
			join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
		Where
			id_status_cp='1'
			And Cd_Tipo_Venda='J'
			and cta.Num_Proc_HEM is null
			and CP.Cd_Tipo_Servico='C'
			AND (CP.Cd_Dst='ALL' and CP.Cd_Org='ALL')
			and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
			and Modal='EM'
			
End /**Regras Gerais**/
GO
