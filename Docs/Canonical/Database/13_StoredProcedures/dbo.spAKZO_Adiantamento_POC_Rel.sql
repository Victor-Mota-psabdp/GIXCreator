SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAKZO_Adiantamento_POC_Rel] --'00001'
(
@POC	varchar(30)
)
as
select AC.Num_Proc,AC.POC from adiantamento_cliente AC 
join adiantamento_poc AP on AP.POC=AC.POC
where AC.POC=@POC and AC.num_proc like '%SUR%'


GO
