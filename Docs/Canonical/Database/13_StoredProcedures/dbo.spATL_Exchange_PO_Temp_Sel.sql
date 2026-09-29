SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_Exchange_PO_Temp_Sel]'0','B'
--sp_help house_temp
--ALTER TABLE dbo.Exchange_PO_Temp ADD Dt_Atd datetime NULL
--ALTER TABLE dbo.Exchange_PO_Temp ADD Dt_Booking datetime NULL
CREATE Procedure [dbo].[spATL_Exchange_PO_Temp_Sel]--'0','B'
(
	@ID			BIGINT,
	@Tipo		char(1)
)

as


if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select top 20
			EXC.ID,EXC.ID_House_Temp,EXC.Intl_Reference,EXC.Num_Proc,EXC.Dt_Ins,EXC.Dt_Envio,EXC.Dt_Retorno,
			I.ATD Dt_Atd,TP5.Dt_conclusao Dt_Booking    
		from
			Exchange_PO_Temp EXC
			join house_temp H with(nolock) on EXC.num_proc = H.num_proc
			join vwHouse_Imp I with(nolock) on I.num_proc = H.num_proc
			Join Tarefas_processos TP5 with(nolock) on TP5.num_proc = H.num_proc 
			and TP5.id_task = 5
		where
				(
					Dt_Envio is null 
					or 
					(
						EXC.Dt_ATD is null and (convert(datetime, I.ATD, 103) > getdate()-30
					)
					or 
					(
						EXC.Dt_Booking is null and TP5.Dt_conclusao > getdate()-30)
					)
				)			
			and H.DT_INS > getdate() -60
			--and Exc.Num_proc in ('IMCTV202205219BR','IMCTV202205217BR')
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			ID,ID_House_Temp,Intl_Reference,Num_Proc,Dt_Ins,Dt_Envio,Dt_Retorno	
		from Exchange_PO_Temp H with(nolock)
		where
			H.ID = @ID
			
	End

GO
