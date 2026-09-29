SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--0833 - DOW BRASIL SUDESTE
--0942 - Dow Agrosciences Industrial
--0031 - Dow Brasil 
--select * from pessoa where nome_raz_soc like  'DOW BRASIL SUDESTE%'
--select * from pessoa where nome_raz_soc like 'DOW BRASIL SA%'
--select * from pessoa where nome_raz_soc like 'DOW AGRO%'

--select * from delete po_him where id_dc = 140

--'IMCSR201110130BR','IMCSR201109265BR','IMCSR20110129701'

CREATE PROCEDURE [dbo].[spCodigodeBarras_InsUpd]--'IMCSR20110129701'

	@Processo		VarChar(16)

as

Begin Transaction

declare @Codigo as varchar(12)
declare @seq varchar(12)
declare @date datetime

set @Codigo = (select (case WHEN P.nome_raz_soc like 'DOW BRASIL SUDESTE%' then '0833'
							WHEN P.nome_raz_soc like 'DOW BRASIL SA%' then	'0031'
							WHEN P.nome_raz_soc like 'DOW AGRO%' then '0942' end) Codigo 
				from house_imp_mar HOU
				join pessoa P on P.cd_pes = HOU.cd_consig_him
				where HOU.num_proc_him = @Processo)

	if @Codigo = '0833'
		begin
			Set @Seq =(select isnull(max(right(NUMERO_PO_HIM,6)) + 1,'15001') FROM PO_HIM where ID_DC = 140 and left(NUMERO_PO_HIM,4) = @codigo)
			Set @seq = '000'+ @Seq
			set @codigo = @codigo + @seq
		end
	
	else if @Codigo = '0031'
		begin
			Set @Seq =(select isnull(max(right(NUMERO_PO_HIM,6)) + 1,'57001') FROM PO_HIM where ID_DC = 140 and left(NUMERO_PO_HIM,4) = @codigo)
			Set @seq = '000'+ @Seq	
			set @codigo = @codigo + @seq
		end

	else if @Codigo = '0942'
		begin
			Set @Seq =(select isnull(max(right(NUMERO_PO_HIM,6)) + 1,'48001') FROM PO_HIM where ID_DC = 140 and left(NUMERO_PO_HIM,4) = @codigo)
			Set @seq = '000'+ @Seq	
			set @codigo = @codigo + @seq
		end
	
	begin
		set @date  = Getdate()
	end

	if len(@codigo) = 12
		BEGIN
			exec spPOHIM_InsUpd Null,@codigo,@date,@Processo,140
		END

	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 
GO
