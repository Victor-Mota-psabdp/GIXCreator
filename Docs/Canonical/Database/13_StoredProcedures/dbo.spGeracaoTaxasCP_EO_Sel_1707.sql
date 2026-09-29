SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGeracaoTaxasCP_EO_Sel_1707]--'EMCSR201411016BR'

@Num_Proc	Varchar(16)
AS

Declare @Grupo	Varchar(10)

if upper(left(@num_proc,2))='EO'
	BEGIN
		Begin
			--Tarifas Gerais por Modal						
			Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
			Insert Cta_Cte_Hou_Exp_Out
						
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Exp_Out CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
					Join House_Exp_Out hou on hou.num_proc_heo=@num_proc 						
					Join LLP_Exp_Out LLP  on num_proC_leo=@num_proc				
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_heo is null
					and CP.Cd_Tipo_Servico='A'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EO'

			UNION ALL

			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					(CASE 
							When (Peso_Bruto_HEO/1000) > Vol_Tot_HEO then
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									(PEso_Bruto_HEO/1000)*CPT.Vlr_Venda
								Else
									(case when(Peso_Bruto_HEO/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
											(case when (PEso_Bruto_HEO/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
												(Peso_Bruto_HEO/1000)*CPT.Vlr_Venda 
											else
												CPT.Vlr_Max_Venda 
											end)								
									else
										CPT.Vlr_Min_Venda 
									end)
								End)
						ELSE
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									Vol_Tot_HEO*CPT.Vlr_Venda 
								Else
										(case when Vol_Tot_HEO*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
												(case when Vol_Tot_HEO*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
													Vol_Tot_HEO*CPT.Vlr_Venda 
												else
													CPT.Vlr_Max_Venda 
												end)
										else
											CPT.Vlr_Min_Venda 
										end)
								End)
						END)
					,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join Cta_Cte_Hou_Exp_Out CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou on hou.num_proc_heo=@num_proc 						
						Join LLP_Exp_Out LLP  on num_proC_leo=@num_proc	
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='K'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
			End

			Begin
				--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR
				Insert Cta_Cte_Hou_Exp_Out
				
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,					 
						'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join Cta_Cte_Hou_Exp_Out CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou on hou.num_proc_heo=@num_proc and cd_consig_heo=cd_cliente
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'		
			
			End

			BEGIN		
				--BUSCA EXATA + DESTINO + IMPORTADOR
			
				Insert Cta_Cte_Hou_Exp_Out 
		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
						'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join Cta_Cte_Hou_Exp_Out  CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out  hou on hou.num_proc_heo=@num_proc and cd_consig_heo=cd_cliente
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'		
						AND (CD_ORG IS NULL OR CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
			End


			BEGIN
		Begin
			--Tarifas Gerais por Modal						
			Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
			
			Insert Cta_Cte_Hou_Exp_Out
										
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Exp_Out CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
					Join House_Exp_Out hou on hou.Num_Proc_HEO=@Num_Proc								
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_heo is null
					and CP.Cd_Tipo_Servico='A'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EO'
		
		insert Cta_Cte_Hou_Exp_Out
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Exp_Out CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
					Join House_Exp_Out hou on hou.num_proc_heo=@Num_Proc	
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 								
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_heo is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EO'
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO, IVA
		insert Cta_Cte_Hou_Exp_Out
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Exp_Out CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
					Join House_Exp_Out hou on hou.num_proc_heo=@Num_Proc	
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 								
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_heo is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EO'
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO, IVA

		insert Cta_Cte_Hou_Exp_Out
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Exp_Out CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
					Join House_Exp_Out hou on hou.num_proc_heo=@Num_Proc									
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_heo is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EO'
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
		Union all
		
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Exp_Out CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
					Join House_Exp_Out hou on hou.num_proc_heo=@Num_Proc								
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_heo is null
					and CP.Cd_Tipo_Servico='C'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EO'	
			END
	end	
END
GO
