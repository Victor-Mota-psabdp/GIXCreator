SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spControleFatura_InsUpd]--'','2012-01-01','2012-01-01','teste','221.00','REL','212.00','2121.00','B',12,1,'fddsfv','fwerfewrf','Demurrage','INFINITY','1213','2012-01-01','IMATL201109004BR','2011-11-30','2012-03-02','Admin'

	@cd_controlefatura		varchar(11),
	@dt_rcto_fatura			datetime,
	@dt_envio_cliente		datetime,
	@cd_protocolo			varchar(50),
	@valor					float,
	@moeda					varchar(50),
	@paridade				float,
	@valor_brl				float,
	@responsabilidade_bdp	char(1),
	@periodo				int,
	@periodo_bdp			int,
	@contato_cliente		varchar(50),
	@analise				varchar(300),
	@tipo_cobranca			varchar(30),
	@fornecedor				varchar(50),
	@num_fatura				varchar(50),
	@dt_vcto_fatura			datetime,
	@job					varchar(16),	
	@periodo_inicial		datetime,
	@periodo_final			datetime,	
	@Cd_Usuario				varchar(20),
	@Reason_descr			varchar(100),
	@cd_controlefatura_Ret	varchar(20) OUTPUT

AS

	Begin Transaction	

	Declare @Lote varchar(15)
	Declare @int as int	
	Declare @contato as varchar(50)	
	Declare @cd_tipo int
	Declare @cd_tp_moeda char(3)
	Declare @cd_fornecedor varchar(10)
	Declare @cd_reason varchar(25)

	set @cd_tp_moeda = (select cd_tp_moeda from tipo_moeda where nome_tp_moeda = @moeda)
--	set @contato = select cd_tp_moeda from tipo_moeda where nome_tp_moeda = @moeda
	set @cd_fornecedor = (select cd_pes from pessoa where apelido = @fornecedor)
	set @cd_tipo = (select id_dc from tipo_Cobranca_Controle_Fatura where nome_doc = @tipo_cobranca)
	set @cd_reason = (select cd_reason from tipo_reason_code where Reason_Descr = @Reason_descr)
	
	
IF @cd_controlefatura = ''
	
	BEGIN			
--	Set @Int=(Select isnull(max(right(left(cd_controlefatura,6),5))+1,1) from Controle_Fatura where year(dt_creacao) = year(getdate()))
--	Set @Lote= convert(nchar(10),getdate(),103)
--	Set @cd_controlefatura = '9' + right('00000'+ Cast(@int as VarChar),5) + right(@lote,5)

	--novo numero 0001/13
	Set @Int=(Select isnull(max(left(cd_controlefatura,4))+1,2458) from Controle_Fatura where year(dt_creacao) = year(getdate()))
--	Set @Lote= year(getdate())
--	Set @cd_controlefatura = right('0000'+ Cast(@int as VarChar),4) + '/' + right(@lote,2)
	
	Set @cd_controlefatura = @Int

			INSERT
				Controle_Fatura(
				cd_controlefatura,dt_rcto_fatura,dt_envio_cliente,cd_protocolo,
				valor,cd_tp_moeda,paridade,valor_brl,responsabilidade_bdp,periodo,periodo_bdp,contato_cliente,
				analise,cd_tipo,cd_fornecedor,num_fatura,dt_vcto_fatura,num_proc,periodo_inicial,
				periodo_final,dt_creacao,cd_usuario,cd_reason
				)
			Values
				(@cd_controlefatura,@dt_rcto_fatura,@dt_envio_cliente,@cd_protocolo,
				@valor,@cd_tp_moeda,@paridade,@valor_brl,@responsabilidade_bdp,@periodo,@periodo_bdp,@contato_cliente,
				@analise,@cd_tipo,@cd_fornecedor,@num_fatura,@dt_vcto_fatura,@job,@periodo_inicial,
				@periodo_final,getdate(),@cd_usuario,@cd_reason
				)

			set @cd_controlefatura_Ret = @cd_controlefatura
			
		END
		
	ELSE
		BEGIN
			UPDATE
				Controle_Fatura
			SET				
				dt_rcto_fatura			= @dt_rcto_fatura,
				dt_envio_cliente		= @dt_envio_cliente,
				cd_protocolo			= @cd_protocolo,
				valor					= @valor,
				cd_tp_moeda				= @cd_tp_moeda,
				paridade				= @paridade,
				valor_brl				= @valor_brl,
				responsabilidade_bdp	= @responsabilidade_bdp,
				periodo					= @periodo,
				periodo_bdp				= @periodo_bdp,
				contato_cliente			= @contato_cliente,
				analise					= @analise,
				cd_tipo					= @cd_tipo,
				cd_fornecedor			= @cd_fornecedor,
				num_fatura				= @num_fatura,
				dt_vcto_fatura			= @dt_vcto_fatura,
				num_proc				= @job,				
				periodo_inicial			= @periodo_inicial,
				periodo_final			= @periodo_final,
				cd_usuario				= @cd_usuario,
				cd_reason				= @cd_reason
			WHERE
				cd_controlefatura		= @cd_controlefatura
			
		END	

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction


GO
