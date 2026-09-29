SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spGeracaoTaxasCP_EM_LOG_Sel] 'EMAMZ201604005BR','Erbson'
create Procedure [dbo].[spGeracaoTaxasCP_EM_Sel] 
		@Num_Proc	Varchar(16),
		@Cd_Usuario varchar(6)
AS


Declare @CtaCte table(

Num_Proc_HEM varchar(16),
Cd_Tp_Tx varchar(3),
DC_HEM char(1),
Org_Ins_HEM varchar(9),
Dt_Ins_HEM varchar(10),
Cd_Tp_Moeda varchar(3),
Vlr_Org_HEM decimal(10, 2),
Dt_Prev_Pgto_HEM varchar(10),
Cd_Cred_Dev_HEM varchar(10),
Desp_Dst_HEM char(1),
CPMF_HEM char(1),
Comp_RP_HEM char(1),
Comp_DN_HEM char(1),
Comp_CN_HEM char(1),
Comp_CPA_HEM char(1),
Num_DCN_HEM varchar(12),
Dt_Ctb_CC_HEM varchar(10),
Num_NF_HEM varchar(12),
Ref_Acesso_NF_HEM char(1),
Vlr_Pgto_NF_HEM decimal(18, 2),
Par_NF_HEM float,
Comp_Job_HEM char(1),
Contab bit,
Vlr_Contab decimal(12, 2),
Contab_Ant bit,
Vlr_Contab_Ant decimal(12, 2),
Contab_Mes_Ano varchar(7),
Val_Con_Comp decimal(12, 2)
)

Begin /**Cria Por Cliente**/

	Begin /**Destino ALL**/
	
		INSERT @CtaCte
			
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.num_proc_hem=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
	
		INSERT @CtaCte
		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
	
		INSERT @CtaCte
		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
		
		INSERT @CtaCte
		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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

	insert @CtaCte
	
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
			Customer_Profile_Taxas CPT with(nolock)
			Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
			Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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
			Customer_Profile_Taxas CPT with(nolock)
			Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
			Left Join @CtaCte CTA on cta.Num_Proc_HEM=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEM='C'		
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

delete Temp from @CtaCte Temp
Join Cta_Cte_Hou_Exp_Mar CTA on Temp.Num_Proc_HEM= CTA.Num_Proc_HEM  and Temp.cd_tp_Tx=CTA.cd_tp_tx and Temp.Dc_hem=CTA.DC_HEM

insert Cta_Cte_Hou_Exp_Mar
select Num_Proc_HEM,
Cd_Tp_Tx,
DC_HEM,
Org_Ins_HEM,
Dt_Ins_HEM,
Cd_Tp_Moeda,
Vlr_Org_HEM,
Dt_Prev_Pgto_HEM,
Cd_Cred_Dev_HEM,
Desp_Dst_HEM,
CPMF_HEM,
Comp_RP_HEM,
Comp_DN_HEM,
Comp_CN_HEM,
Comp_CPA_HEM,
Num_DCN_HEM,
Dt_Ctb_CC_HEM,
Num_NF_HEM,
Ref_Acesso_NF_HEM,
Vlr_Pgto_NF_HEM,
Par_NF_HEM,
Comp_Job_HEM,
Contab,
Vlr_Contab,
Contab_Ant,
Vlr_Contab_Ant,
Contab_Mes_Ano,
Val_Con_Comp from @CtaCte


insert Log_Cta_Cte
select 
getdate(),
@Cd_Usuario,
'I',
Num_Proc_HEM,
Cd_Tp_Tx,
DC_HEM,
Org_Ins_HEM,
Dt_Ins_HEM,
Cd_Tp_Moeda,
Vlr_Org_HEM,
Dt_Prev_Pgto_HEM,
Cd_Cred_Dev_HEM,
Desp_Dst_HEM,
CPMF_HEM,
Comp_RP_HEM,
Comp_DN_HEM,
Comp_CN_HEM,
Comp_CPA_HEM,
Contab,
Vlr_Contab,
Contab_Ant,
Contab_Mes_Ano from @CtaCte
GO
