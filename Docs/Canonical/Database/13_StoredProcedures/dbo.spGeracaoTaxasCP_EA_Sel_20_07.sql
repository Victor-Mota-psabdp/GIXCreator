SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGeracaoTaxasCP_EA_Sel_20_07]-- [dbo].[spGeracaoTaxasCP_EA_Sel] 'EACSR201505001BR'
			@Num_Proc	Varchar(16)
AS

Declare @Grupo	Varchar(10)
Declare @CdPedido varchar(50)

if upper(left(@num_proc,2))='EA'
	BEGIN
			--Tarifas Gerais por Modal						




			
			Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
			
						
----Amostra
--			set @CdPedido = (select top 1 P.cd_pedido from Pedido_Ship PS 
--			join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
--			join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 
--			where @Num_Proc = PS.Num_Proc)
--			if @CdPedido is not null
--			Begin

--			Insert CtA_cte_hou_exp_aer
--				Select 
--						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
--						Cd_Tp_Moeda_Venda,
--						CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
--						Cd_Export_HEA,
--						'N',	
--							case IVA
--								when 'N' then 'S'
--								else 'N'
--							end
--						,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
--				From
--						Customer_Profile_Taxas CPT
--						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--						Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
--						Join House_exp_aer hou on hou.num_proc_hea=@Num_Proc						
--						Join LLP_exp_aer LLP  on num_proC_lea=@Num_Proc
						
--				Where
--						id_status_cp='1'
--						And Cd_Tipo_Venda='J'
--						and cta.num_proc_hea is null
--						and CP.Cd_Tipo_Servico='B'		
--						AND CD_CLIENTE='1'
--						AND (cd_DST='ALL' and CD_ORG='ALL')
--						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
--						and Modal='EA'
--						and CPT.Cd_Tp_Tx = 'SR2'
--			end
		
			Insert CtA_cte_hou_exp_aer			
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='A'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EA'

			UNION ALL

			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					(CASE 
							When (PEso_Bruto_HEA/1000) > Vol_Tot_HEA then
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									(PEso_Bruto_HEA/1000)*CPT.Vlr_Venda
								Else
									(case when(PEso_Bruto_HEA/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
											(case when (PEso_Bruto_HEA/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
												(PEso_Bruto_HEA/1000)*CPT.Vlr_Venda 
											else
												CPT.Vlr_Max_Venda 
											end)								
									else
										CPT.Vlr_Min_Venda 
									end)
								End)
						ELSE
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									Vol_Tot_HEA*CPT.Vlr_Venda 
								Else
										(case when Vol_Tot_HEA*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
												(case when Vol_Tot_HEA*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
													Vol_Tot_HEA*CPT.Vlr_Venda 
												else
													CPT.Vlr_Max_Venda 
												end)
										else
											CPT.Vlr_Min_Venda 
										end)
								End)
						END)
					,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
						Join LLP_exp_aer LLP  on num_proC_lea=@num_proc	
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='K'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'
						and CPT.Cd_Tp_Tx not in('SR2')
			End

			Begin
				--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR
				Insert CtA_cte_hou_exp_aer
				
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,					 
						'N','N','N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer hou on hou.num_proc_hea=@num_proc and cd_consig_hea=cd_cliente and num_proc_mea <> 'JOB' and cd_org=cd_org_hea and cd_dst=cd_dst_hea
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'		
			
			End

			BEGIN		
				--BUSCA EXATA + DESTINO + IMPORTADOR
			
				Insert CtA_cte_hou_exp_aer 
		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
						'N','N','N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_exp_aer  CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer  hou on hou.num_proc_hea=@num_proc and cd_consig_hea=cd_cliente and num_proc_mea <> 'JOB' and cd_dst=cd_dst_hea
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'		
						AND (CD_ORG IS NULL OR CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'
			End


			BEGIN
				--BUSCA POR GRUPO E DESTINO
				
				Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
				
				Insert CtA_cte_hou_exp_aer 
		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
						'N','N','N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_exp_aer  CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer  hou on hou.num_proc_hea=@num_proc and cd_dst=cd_dst_hea
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (CD_ORG IS NULL OR CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'
			
			Insert CtA_cte_hou_exp_aer 							
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'	
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,
					Cd_Export_HEA,
					IVA
			union all		
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'	
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,
					Cd_Export_HEA,
					IVA
	
			Insert CtA_cte_hou_exp_aer 
					Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido 
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'	
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
			UNION ALL
										
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='C'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'
				
				
	END
GO
