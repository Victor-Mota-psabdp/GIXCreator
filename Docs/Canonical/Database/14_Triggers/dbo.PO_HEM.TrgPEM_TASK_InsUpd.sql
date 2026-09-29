SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgPEM_TASK_InsUpd] ON [dbo].[PO_HEM] 
FOR INSERT,UPDATE
AS
	Declare @Processo varchar(16)
	Select @Processo = num_proc_hem from inserted 
	
	Declare @ID_DC as int
	Select @ID_DC= id_dc from inserted
	
	Declare @Data_PO_HEM as Datetime
	select @Data_PO_HEM = Data_PO_HEM from inserted
	
	--trigger para incluir a data do task: 
	--10	Saída da Planta	EM
	
	if (@id_dc = 10 AND CONVERT(date,@Data_PO_HEM) <= CONVERT(date,getdate()))
	BEGIN
		DEclare @data datetime
		set @data = (select GETDATE())
		
		if exists(select TP10.Num_Proc from vwHouse_Exp HOU
				JOIN Pessoa SHIP	with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
				JOIN Pessoa_LLP PLL	with(nolock) on SHIP.Cd_Pes = PLL.Cd_Pes
				JOIN Grupo G		with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
				JOIN pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
				join Tarefas_Processos TP10 with(nolock) on TP10.Num_Proc = HOU.Num_Proc and TP10.ID_Task = 10
			where
				PG.Apelido in ('GRUPO DOW','GRUPO BLUE CUBE','GRUPO CBE','GRUPO CPE') 
				and TP10.Dt_Conclusao is null and TP10.Num_Proc = @Processo)				
				BEGIN
					update
						Tarefas_Processos
					set
						Dt_Conclusao = @Data_PO_HEM,
						Cd_Usuario = 'ATL'
					where
						Num_Proc = @Processo 
						and ID_Task = 10
					
					exec dbo.[spHistG_InsUPD] @Processo,Null ,Null,'CSR','Task: Saída da Planta preenchido pela inclusão da Referencia: 010 - Nota Fiscal' ,@data,null ,'ATL System','N','U',null 	
				END
	END



GO
ALTER TABLE [dbo].[PO_HEM] ENABLE TRIGGER [TrgPEM_TASK_InsUpd]
GO
