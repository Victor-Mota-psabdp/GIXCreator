SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [dbo].[Exchange_SLI] where num_solicitacao = 'SLI2016100001'
--select * from [dbo].[Solicitacao_LI] where num_solicitacao = 'SLI2016100001'
CREATE TRIGGER [dbo].[TrgSLI_InsUpd] ON [dbo].[Solicitacao_LI] 
FOR INSERT, UPDATE
AS
	
	
	--Para enviar email ao cliente sobre a solicitação de LI
	--Tipo L - DT_LI
	--Tipo A - DT Autorixzacao
	--Tipo D - Dt Deferimento
	Declare	@Num_LI as varchar(50)
	Declare	@Num_Proc as varchar(16)
	Declare @Tipo as varchar(1)
	Declare	@cd_grupo as varchar(10)
	Declare	@Dt_LI as DateTime
	Declare	@Dt_Aut_Embarque  as DateTime
	Declare	@Dt_Deferimento as DateTime
	
	select @cd_grupo = Cd_Grupo from inserted		
	select @Num_LI = Num_LI from inserted
	select @Num_Proc = Num_Proc from inserted
	select @Dt_LI = Dt_LI from inserted
	select @Dt_Aut_Embarque = Dt_Aut_Embarque from inserted
	select @Dt_Deferimento = Dt_Deferimento from inserted

	Declare @Num_Solicitacao	varchar(13)
	Declare @Tipo_Oper			char(1)
	Declare @Cd_usuario_Oper	varchar(10)
	Select @Num_Solicitacao	 = Num_Solicitacao from inserted 
	select @Cd_Usuario_Oper = Cd_Usuario_Oper from inserted
	
	BEGIN
		if @cd_usuario_oper is null 
			Begin 
				Set @Tipo_Oper='I'	
			End
		else
			Begin
				set @Tipo_Oper='A'
			End
		insert into solicitacao_li_log 
			(num_solicitacao,Tipo_Oper,Dt_Alteracao) 
		values
			(@num_solicitacao,@Tipo_Oper,getdate())
	END

	BEGIN
	
		if @Num_LI is not null and @Num_Proc is not null
			Begin
				IF @Dt_LI is not null and @Dt_Aut_Embarque is null and @Dt_Deferimento is null				
						if not exists(Select num_solicitacao from Exchange_SLI where [Num_Solicitacao] = @Num_Solicitacao and [Type]= 'L')
							begin
								set @Tipo = 'L'	--Dt_LI
							End				
				IF @Dt_LI is not null and @Dt_Aut_Embarque is not null			
						if not exists(Select num_solicitacao from Exchange_SLI where [Num_Solicitacao] = @Num_Solicitacao and [Type]= 'A')
							begin
								set @Tipo = 'A'	--Dt_Aut_Embarque
							End		
					
				IF @Dt_LI is not null and @Dt_Deferimento is not null				
						if not exists(Select num_solicitacao from Exchange_SLI where [Num_Solicitacao] = @Num_Solicitacao and [Type]= 'D')
							begin
								set @Tipo = 'D'	--Dt_Deferimento
							End	
					
				If @Tipo is not null and @cd_grupo in ('P000008256','P000000450','P000027658')
					if not exists(Select num_solicitacao from Exchange_SLI where [Num_Solicitacao] = @Num_Solicitacao and [Type]= @Tipo)
						BEGIN
							insert into Exchange_SLI 
								([Num_Solicitacao],[Type],[Dt_Ins])
							values
								(@Num_Solicitacao,@Tipo,getdate())
						END 
			End
		
	END
GO
ALTER TABLE [dbo].[Solicitacao_LI] ENABLE TRIGGER [TrgSLI_InsUpd]
GO
