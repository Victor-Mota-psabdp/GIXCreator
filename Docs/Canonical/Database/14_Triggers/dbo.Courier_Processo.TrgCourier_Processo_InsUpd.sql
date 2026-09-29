SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgCourier_Processo_InsUpd] ON [dbo].[Courier_Processo] For Insert,Update

AS 
BEGIN
	
	Declare	@Num_Proc as Varchar(16)
	Select @Num_Proc=Num_Proc from inserted

	Declare @Dt_courier as Datetime
	select @Dt_courier = Dt_courier from inserted
	
--trigger para incluir a data do task: 
--12	Envio de Docs	EM


if (LEFT(@Num_Proc,2) = 'EM' AND CONVERT(date,@Dt_courier) <= CONVERT(date,getdate()))
	BEGIN
		DEclare @data datetime
		SEt @data = (select GETDATE())
		if exists(
			select 
				TP12.Num_Proc 
			from 
				House_EXP_Mar HOU
				JOIN Pessoa SHIP	with(nolock) on Hou.Cd_Export_HEM = SHIP.Cd_Pes
				JOIN Pessoa_LLP PLL	with(nolock) on SHIP.Cd_Pes = PLL.Cd_Pes
				JOIN Grupo G		with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
				JOIN pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
				join Tarefas_Processos TP12 with(nolock) on TP12.Num_Proc = HOU.Num_Proc_HEM and TP12.ID_Task = 12
			where
				PG.Apelido in ('GRUPO DOW','GRUPO BLUE CUBE','GRUPO CBE','GRUPO CPE') 
				and Dt_Conclusao is null
				and TP12.Num_Proc = @Num_Proc)
		
			BEGIN
				update
					Tarefas_Processos
				set
					Dt_Conclusao = @Dt_courier,
					Cd_Usuario = 'ATL'
				where
					Num_Proc = @Num_Proc  and ID_Task = 12
					
				exec dbo.[spHistG_InsUPD] @Num_Proc,Null ,Null,'CSR','Task: Envio de Docs preenchido pelo Courier' ,@data,null ,'ATL System','N','U',null 
			END
				
				
		
	END
	
END
GO
ALTER TABLE [dbo].[Courier_Processo] ENABLE TRIGGER [TrgCourier_Processo_InsUpd]
GO
