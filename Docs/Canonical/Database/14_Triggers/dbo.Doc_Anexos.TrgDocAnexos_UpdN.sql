SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from tipo_doc_cliente where Historico = 'S'
--select * from Doc_Anexos_Historico

CREATE TRIGGER [dbo].[TrgDocAnexos_UpdN] ON [dbo].[Doc_Anexos]
FOR  UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @id_dc		Int
	Declare @historico char(1)
	Declare @Nome_DC varchar(100)
	Declare @Mensagem varchar(2500)
	Declare @QTY		Int
	
	Select @Processo = Num_Proc from inserted 
	Select @id_dc=id_dc from inserted	
	Set @historico=(select isnull(historico,'N') from tipo_doc_cliente with(nolock) where ID_DC = @id_dc)	
	Set @Nome_DC=(select Nome_DC from tipo_doc_cliente with(nolock) where ID_DC = @id_dc)	
	Set @Mensagem =(select 'Documento: ' + @Nome_DC + ' alterado dia: ' + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(30),getdate(),114))
	set @QTY = (select count(Num_Proc) from Doc_Anexos_Historico with(nolock) where Num_Proc =@Processo and Id_DC = @id_dc)
	
	Declare @anexado_em as Datetime
	Select @anexado_em  = Anexado_Em from inserted
	
	Declare @anexado_del as Datetime
	Select @anexado_del  = Anexado_Em from deleted
	
	if (@anexado_em <> @anexado_del	or @anexado_del is null) 	
		if @Processo is not null	
			if @historico = 'S' and LEFT(@Processo,1) = 'I'
				BEGIN			
					if @QTY > 1
						Begin
							Insert hist_geral
								select 
									Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=num_proc) Seq,null,
									108,@Mensagem + ' , histórico gerado por  ' + Nome_usuario ,
									getdate(),null,'ATL' Usuario,null,'N','U',null
								from 
									Doc_Anexos DA	with(nolock)						
									Left Join Usuario US with(nolock) on US.cd_usuario=isnull(DA.cd_usuario,'ATL')
								where
									num_proc=@processo and Id_DC = @id_dc
							
						End
				END
	
GO
ALTER TABLE [dbo].[Doc_Anexos] ENABLE TRIGGER [TrgDocAnexos_UpdN]
GO
