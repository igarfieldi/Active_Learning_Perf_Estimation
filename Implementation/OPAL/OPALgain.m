## Copyright (C) 2014 Georg Krempl, Daniel Kottke
##
## Author: Georg Krempl <georg.krempl@ovgu.de>
## 
## If using this method, please cite the paper:
##   Optimised Probabilistic Active Learning
##   by Georg Krempl, Daniel Kottke, Vincent Lemaire
##
## You should have received a copy of the GNU General Public
## License along with Octave; see the file COPYING.  If not,
## see <http://www.gnu.org/licenses/>.


## usage: [val] = OPALgain(n,pObs,tau,m)
##
## Caculates the opal gain for given parameters:
##   n    - number of labelled instances
##   pObs - share of positives among labelled instances
##   tau  - cost-ratio = FP/(FP+FN)
##   m    - labelling budget size
## 
## Example:
##  pObsValues = linspace(0,1,101);
##  val = OPALgain(1,pObsValues,.4,2);
##  plot(pObsValues, val)
##  

function val = OPALgain(n,pObs,tau,m)
  val = Iml(n,pObs,tau,0,0);
  for k=0:m
    val = val - Iml(n,pObs,tau,m,k);
  end
  val = binom(n,n.*pObs) .* (n+1)./m .* val;
end

## subfunctions
function val = binom(m,k)
  val = gamma(m+1)./(gamma(k+1).*gamma(m-k+1));
end

function val = Iml(n,pObs,tau,m,k)
  conditions = (n.*pObs+k)./(n+m);
  val = nan(size(conditions));
  valLess    = (1-tau)      .* gamma(1-k+m+n-n.*pObs).*gamma(2+k+n.*pObs)./gamma(3+m+n);
  valEq      = (tau-tau.^2) .* gamma(1-k+m+n-n.*pObs).*gamma(1+k+n.*pObs)./gamma(2+m+n);
  valGreater = (tau)        .* gamma(2-k+m+n-n.*pObs).*gamma(1+k+n.*pObs)./gamma(3+m+n);
  val(conditions<tau) = valLess(conditions<tau);
  val(conditions==tau) = valEq(conditions==tau);
  val(conditions>tau) = valGreater(conditions>tau);
  val = binom(m,k).*val;
end
