SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRelaDow_IMP_NEW]--'Grupo Dow','2013-03-30','2013-09-27'
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
as


	Declare @cd_pes_grupo varchar(10)
	set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	--set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

	select Distinct
			hou.Num_Proc_HIM									[BDP Ref],
			hou.MAWB_HIM										[Master],
			HAWB_HIM											[House],
			Num_Pedido											[Order], 
			Isnull(PO.numero_po_him,Num_Po)						[N. PO],
			isnull(Customer_PO.numero_PO_HIM,Customer_PO)		[Customer PO],
			Org.Nome_Local										[Origem],
			Dst.Nome_Local										[Destino],
			Nome_Armador										[Armador],
			Navio_HIM											[Navio], 
			ETD_LIM												[ETD],
			ATD_LIM												[ATD], 
			ETA_LIM												[ETA],
			ATA_LIM												[ATA],
			TP.Dt_Conclusao										[Desembaraco],
			Business_Group_Descr								[Business Group],
			'Marítimo'											[Modal],
			--dbo.FBusca_Adto(hou.num_proc_him)					[Dt. Adto], 
			--dbo.FBusca_Caixa(hou.num_proc_him)					[Rcto. Adto], 
			--dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_him)[Histórico],
			[Dt. Adto],
			[Rcto. Adto],
			[Histórico],
			DI.Numero_PO_Him									[DI], 
			DI.Data_PO_Him										[Data DI],
			Canal_Lim											[Channel]	
		from				
			house_imp_mar				HOU		With(nolock)
			Join Pessoa_LLP				PLL		With(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@cd_pes_grupo
			Join LLp_imp_mar			LLP		With(nolock) on hou.num_proc_HIM = LLP.num_proc_LIM
			left Join Job_imp_mar		JOB		With(nolock) on JOB.num_proc_him=hou.num_proc_him
			left Join Armador			ARM		With(nolock) on ARM.cd_armador=job.cd_armador	
			left join RelaDowIMP		NET		with(nolock) on HOU.Num_Proc_HIM	= NET.Ref_BDP
			Left Join Tarefas_Processos	TP		With(nolock) on hou.num_proc_HIM = TP.num_proc and TP.ID_Task=4
			Left Join Tarefas_Processos ENTREGA	With(nolock) on hou.num_proc_HIM = ENTREGA.num_proc	and ENTREGA.ID_Task=13
			left Join Pedido_Ship		PS		With(nolock) on PS.num_proc=hou.num_proc_HIM
			left Join Pedido			PD		With(nolock) on PD.cd_pedido=PS.cd_pedido
			Left Join Pedido_Det		PDET	With(nolock) on PDET.cd_pedido=PS.cd_pedido
			left Join Produto_cliente	PC		With(nolock) on PC.cd_prod=ps.cd_produto
			left Join DE_Para_Produto	DP		With(nolock) on DP.gmid=cd_proc_cliente
			left Join Localidade		Org		With(nolock) on hou.cd_org_HIM=Org.cd_local
			left Join Localidade		Dst		With(nolock) on cd_dst_HIM=DSt.cd_local	
			Left Join PO_HIM			DI		With(nolock) on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
			Left Join PO_HIM			PO		With(nolock) on PO.Num_Proc_Him=hou.num_proc_him and PO.id_dc=1
			Left Join PO_HIM			Customer_PO With(nolock) on Customer_PO.Num_Proc_Him=hou.num_proc_him and Customer_PO.id_dc=9
		where
			Etd_Lim between @DtInicial and @DtFinal and	
			--right(left(HOU.Num_proc_HIM,5),3)  = @Grupo and
			ENTREGA.Dt_Conclusao is null and PD.status <> 'E' 
			and isnull(id_status,0) <> '9'

		UNION ALL

		select Distinct
				hou.Num_Proc_HIA									[BDP Ref],
				hou.MAWB_HIA										[Master],
				HAWB_HIA											[House],
				Num_Pedido											[Order], 
				Isnull(PO.numero_po_hia,Num_Po)						[N. PO],
				isnull(Customer_PO.numero_PO_HIA,Customer_PO)		[Customer PO],
				Org.Nome_Local										[Origem],
				Dst.Nome_Local										[Destino],
				Nome_Cia_Aer											Armador,
				Voo_HIA													Navio,
				ETD_LIA												[ETD],
				ATD_LIA												[ATD], 
				ETA_LIA												[ETA],
				ATA_LIA												[ATA],
				TP.Dt_Conclusao										[Desembaraco],
				Business_Group_Descr								[Business Group],
				'Aéreo'												[Modal],
				--dbo.FBusca_Adto(hou.num_proc_hia)					[Dt. Adto], 
				--dbo.FBusca_Caixa(hou.num_proc_hia)					[Rcto. Adto], 
				--dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hia)[Histórico],
				[Dt. Adto],
				[Rcto. Adto],
				[Histórico],
				DI.Numero_PO_Hia									[DI], 
				DI.Data_PO_Hia										[Data DI],
				Canal_Lia											[Canal]
			from
				house_imp_AER				HOU		With(nolock)
				Join Pessoa_LLP				PLL		With(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@cd_pes_grupo		
				Join LLp_imp_AER			LLP		With(nolock) on LLP.num_proc_LIA=hou.num_proc_HIA
				left Join Job_imp_aer		JOB		With(nolock) on JOB.num_proc_hia=HOU.num_proc_hia
				left Join Cia_Aerea			ARM		With(nolock) on ARM.cd_cia_Aer=job.cd_cia_aer		
				left join RelaDowIMP		NET		with(nolock) on HOU.Num_Proc_HIA	= NET.Ref_BDP
				Left Join Tarefas_Processos TP		WITH (NOLOCK) on hou.num_proc_HIA=TP.num_proc and TP.ID_Task=4
				Left Join Tarefas_Processos ENTREGA	WITH (NOLOCK) on hou.num_proc_HIA=ENTREGA.num_proc and ENTREGA.ID_Task=13
				left Join Pedido_Ship		PS		With(nolock) on PS.num_proc=hou.num_proc_HIA
				left Join Pedido			PD		With(nolock) on PD.cd_pedido=PS.cd_pedido
				Left Join Pedido_Det		PDET	With(nolock) on PDET.cd_pedido=PS.cd_pedido
				left Join Produto_cliente	PC		With(nolock) on PC.cd_prod=ps.cd_produto
				left Join DE_Para_Produto	DP		With(nolock) on DP.gmid=cd_proc_cliente
				left Join Localidade		Org		With(nolock) on hou.cd_org_HIA=Org.cd_local
				left Join Localidade		Dst		With(nolock) on cd_dst_HIA=DSt.cd_local		
				Left Join PO_HIA			DI		With(nolock) on DI.Num_Proc_Hia=hou.num_proc_hia and id_dc=5
				Left Join PO_HIA			PO		With(nolock) on PO.Num_Proc_Hia=hou.num_proc_hia and PO.id_dc=1
				Left Join PO_HIA			Customer_PO With(nolock) on Customer_PO.Num_Proc_Hia=hou.num_proc_hia and Customer_PO.id_dc=9
			where
				Etd_Lia between @DtInicial and @DtFinal and
				--right(left(HOU.Num_proc_HIA,5),3)  = @Grupo and
				ENTREGA.Dt_Conclusao is null and PD.status <> 'E'
				and isnull(id_status,0) <> '9' 

		UNION ALL
			select Distinct
				hou.Num_Proc_HIO									[BDP Ref],
				hou.MAWB_HIO										[Master],
				HAWB_HIO											[House],
				Num_Pedido											[Order], 
				Isnull(PO.numero_po_hiO,Num_Po)						[N. PO],
				isnull(Customer_PO.numero_PO_HIO,Customer_PO)		[Customer PO],
				Org.Nome_Local										[Origem],
				Dst.Nome_Local										[Destino],
				Nome_Raz_Soc										Armador,
				Null												Navio,
				ETD_LIO												[ETD],
				ATD_LIO												[ATD], 
				ETA_LIO												[ETA],
				ATA_LIO												[ATA],
				TP.Dt_Conclusao										[Desembaraco],
				Business_Group_Descr								[Business Group],
				(CASE WHEN Tipo_LIO = 'T' then 'Rodoviário'			
					else 'Ferroviário' end)							[Modal],		
				--dbo.FBusca_Adto(hou.num_proc_hiO)					[Dt. Adto], 
				--dbo.FBusca_Caixa(hou.num_proc_hiO)					[Rcto. Adto], 
				--dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hiO)[Histórico],
				[Dt. Adto],
				[Rcto. Adto],
				[Histórico],
				DI.Numero_PO_HiO									[DI], 
				DI.Data_PO_HiO										[Data DI],
				Canal_LiO											[Canal]
			from
				house_imp_out		HOU		With(nolock)
				Join Pessoa_LLP		PLL		With(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo=@cd_pes_grupo
				Join LLp_imp_out	LLP		With(nolock) on LLP.num_proc_LIO=hou.num_proc_HIO
				left Join Pessoa	ARM		With(nolock) on ARM.cd_pes=llp.cd_carrier
				left join RelaDowIMP NET	with(nolock) on HOU.Num_Proc_HIO= NET.Ref_BDP
				
				Left Join Tarefas_Processos	TP	WITH(NOLOCK) on	hou.num_proc_HIO=TP.num_proc and TP.ID_Task=4		
				Left Join Tarefas_Processos	ENTREGA	WITH(NOLOCK) on	hou.num_proc_HIO=ENTREGA.num_proc and ENTREGA.ID_Task=13
				left Join Pedido_Ship		PS With(nolock) on PS.num_proc=hou.num_proc_HIO
				left Join Pedido			PD With(nolock) on PD.cd_pedido=PS.cd_pedido
				Left Join Pedido_Det		PDET With(nolock) on PDET.cd_pedido=PS.cd_pedido
				left Join Produto_cliente	PC With(nolock) on PC.cd_prod=ps.cd_produto
				left Join DE_Para_Produto	DP With(nolock) on DP.gmid=cd_proc_cliente
				left Join Localidade		Org With(nolock) on hou.cd_org_HIO=Org.cd_local
				left Join Localidade		Dst With(nolock) on cd_dst_HIO=DSt.cd_local	
				Left Join PO_HIO			DI With(nolock) on DI.Num_Proc_Hio=hou.num_proc_hio and id_dc=5
				Left Join PO_HIo			PO With(nolock) on PO.Num_Proc_HiO=hou.num_proc_hiO and PO.id_dc=1
				Left Join PO_HIO			Customer_PO With(nolock) on Customer_PO.Num_Proc_HiO=hou.num_proc_hiO and Customer_PO.id_dc=9
			where
				Etd_LiO between @DtInicial and @DtFinal and
				--right(left(HOU.Num_proc_HIo,5),3) = @Grupo and
				ENTREGA.Dt_Conclusao is null and PD.status <> 'E'
				and isnull(id_status,0) <> '9'
				
			order by 1
		

GO
