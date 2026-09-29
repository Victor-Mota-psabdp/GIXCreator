SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Solicitacao_LI where Num_Proc like 'IMOXt2018%'
--select [dbo].[fBusca_Solicitacao_LI_DadosCompletos]('IMOXT201801028BR')
CREATE FUNCTION [dbo].[fBusca_Solicitacao_LI_DadosCompletos]--'IMOXT201802010BR'
(
	@Processo Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN
	
 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for 
     	select 
     		'Numero da LI: ' + isnull(Num_LI,' ') + '|' +
		    'Data de Emissão da LI: ' + isnull(convert(varchar(10),Dt_LI,103),' ') + '|' +
		    'Data do Deferimento da LI: ' + isnull(convert(varchar(10),Dt_Deferimento,103),' ')+ '|' +
		    'Data do Vencimento da LI: ' + isnull(convert(varchar(10),Dt_Vencimento,103),' ')+ '|'
		from Solicitacao_LI     	 
     		where Num_Proc = @Processo 
     		and id_status not in (7,8,11,12) 
     		and Num_LI is not null
----------------------------------------------------------------------------
		open Cur_CONT
			Fetch Next From Cur_CONT Into @CONT
			While @@FETCH_STATUS = 0
			Begin
				if @N_CONT='' or @N_CONT is Null
					Begin
						Set @N_CONT=@CONT
					end
				else
					begin
						set @N_CONT=@N_CONT + '|'  + @CONT
					end
				
				Fetch Next From Cur_CONT Into @CONT
			end
		close Cur_CONT
		deallocate Cur_CONT 
		
	return @N_CONT
	
END

--- Numero da LI (Informação da SLI) 
--- Data de emissão da LI (Informação da SLI) 
--- Data do deferimento da LI (Informação da SLI) 
--- Data do vencimento da LI (Informação da SLI) 

--1	Aguardando Definição de Operador
--2	Aguardando Registro
--3	Em Analise
--4	Em Exigência
--5	Deferida
--6	Deferida e Utilzada
--7	Deferida e Cancelada
--8	Solicitação Cancelada
--9	Embarque Autorizado
--10	Pendente
--11	Indeferida
--12	LI - Cancelada









GO
