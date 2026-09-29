SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Container_Temp_Additional_Info
CREATE Procedure [dbo].[spContainer_Temp_Additional_Info_Sel]--'2'
(
	@ID			BIGINT,
	@Tipo		char(1)
)

as
	--select ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,Item_Cont_IM,
	--		Cd_Tp_Cont,Num_Cont_IM,
	--		dt_entregaPlanta,dt_entregaArmazem,dt_saidaArmazem,dt_saidaVazio,local_entrega,
	--		dt_devolucao,local_entrega_vazio,Mercadoria,cd_usuario,dt_ins,ativo,Peso_Bruto_EM_VGM,
	--		UOM_VGM,Dt_Envio_VGM,Nome_Responsavel_VGM,Metodo_VGM,TatcNumber,dt_ReleaseTatc,Itinerary_ID
	--from Container_Temp_Additional_Info
	--where
	--	ID = @ID
		

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select 
			convert(varchar(25),'Saved')		[Status],
			HOU.ID								[ID],
			HOU.ID_Req							[ID Req],
			HOU.Intl_Reference					[Intl Reference],
			HOU.Num_Proc						[JOB],
			HOU.Item_Cont_IM					[Item],
			HOU.Num_Cont_IM						[Reference],	
			dt_entregaPlanta					[Delivery Plant Date],
			dt_entregaArmazem					[Warehouse Delivery Date],
			dt_saidaArmazem						[Warehouse Exit Date],
			dt_saidaVazio						[Empty Exit Date],
			local_entrega						[Cargo Delivery Location],
			dt_devolucao						[Return Date],
			local_entrega_vazio					[Empty Container Delivery Location],
			Mercadoria							[Description and Goods],
			ISNULL(HOU.cd_usuario,'ATL')		[User Code],
			US.Nome_Usuario						[User Name],
			dt_ins								[Insert Date],
			ISNULL(ativo,'true')					[Enabled],
			Peso_Bruto_EM_VGM					[VGM Gross Weight],
			UOM_VGM								[VGM UOM],
			Dt_Envio_VGM						[VGM Reported Date],
			Nome_Responsavel_VGM				[VGM Name Responsible],
			Metodo_VGM							[VGM Method Type Code],
			TM.ID_Metodo_VGM					[VGM Method Type Name],			
			TatcNumber							[TatcNumber],
			dt_ReleaseTatc						[Release TACT Date],
			Itinerary_ID						[Itinerary ID]
		from Container_Temp_Additional_Info HOU
			LEFT JOIN Usuario US ON US.Cd_Usuario = ISNULL(HOU.cd_usuario,'ATL')
			LEFT JOIN Tipo_Metodo_VGM TM ON TM.ID_Metodo_VGM = HOU.Metodo_VGM
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved')		[Status],
			HOU.ID								[ID],
			HOU.ID_Req							[ID Req],
			HOU.Intl_Reference					[Intl Reference],
			HOU.Num_Proc						[JOB],
			HOU.Item_Cont_IM					[Item],
			HOU.Num_Cont_IM						[Reference],	
			dt_entregaPlanta					[Delivery Plant Date],
			dt_entregaArmazem					[Warehouse Delivery Date],
			dt_saidaArmazem						[Warehouse Exit Date],
			dt_saidaVazio						[Empty Exit Date],
			local_entrega						[Cargo Delivery Location],
			dt_devolucao						[Return Date],
			local_entrega_vazio					[Empty Container Delivery Location],
			Mercadoria							[Description and Goods],
			ISNULL(HOU.cd_usuario,'ATL')		[User Code],
			US.Nome_Usuario						[User Name],
			dt_ins			[Insert Date],
			ISNULL(ativo,'true')					[Enabled],
			Peso_Bruto_EM_VGM					[VGM Gross Weight],
			UOM_VGM								[VGM UOM],
			Dt_Envio_VGM						[VGM Reported Date],
			Nome_Responsavel_VGM				[VGM Name Responsible],
			Metodo_VGM							[VGM Method Type Code],
			TM.ID_Metodo_VGM					[VGM Method Type Name],			
			TatcNumber							[TatcNumber],
			dt_ReleaseTatc						[Release TACT Date],
			Itinerary_ID						[Itinerary ID]
		from Container_Temp_Additional_Info HOU
			LEFT JOIN Usuario US ON US.Cd_Usuario = ISNULL(HOU.cd_usuario,'ATL')
			LEFT JOIN Tipo_Metodo_VGM TM ON TM.ID_Metodo_VGM = HOU.Metodo_VGM
		where
			HOU.ID = @ID
	End

GO
