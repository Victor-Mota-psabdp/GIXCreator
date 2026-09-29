SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spMiro_Reenvio_UPD_Sel]
(
	@num_proc	varchar(16),
	@id_evento	varchar(3)
)
as

	if 	@id_evento <> 'all'
		begin
			if exists(select fatura_pc from FMC_Miro where fatura_pc = @num_proc and ID_Evento = @id_evento)
				begin
					update FMC_Miro set Mensagem_Retorno =null,Dt_Alerta =null,Status='C',Dt_Retorno = null 
					where fatura_pc = @num_proc and ID_Evento = @id_evento
				end
		end
	else
		begin
			update Custo_Cliente set Num_NF_Custo= null where Num_Proc = @num_proc
			
			delete FMC_Miro where fatura_pc = @num_proc
		end
		
	

GO
